#!/bin/bash

PROGNAME=$0

usage() {
  cat << EOF >&2

Usage: $PROGNAME [-t] [-a|-p|-s PKG_NAME] [-j JOBS] [-c] | -r PKG_NAME

Options
-a          : Check and update all packages
-p          : Update Plugins only
-s PKG_NAME : Check and update single package PKG_NAME
-t          : Dry run, only show available updates (alone: for all packages)
-j JOBS     : Number of packages checked in parallel (default: 8)
-c          : Show the commits between old and new version
-r PKG_NAME : reset package PKG_NAME to HEAD
--help      : Show this help
EOF
  exit ${1:-1}
}

# print the value of variable $1 (e.g. PKG_NAME) set in package.mk $2
pkg_var() {
  sed -n "s/^$1=\"\(.*\)\"\s*$/\1/p" "$2" | head -1
}

reset_package() {
  if [[ -z "$1" ]]; then
    echo "ERROR: no PKG_NAME given"
    usage
  fi

  FOUND=""
  packages=($(find packages -name package.mk))

  for (( i=0; i<${#packages[@]}; i++ )); do
    if [[ "$1" != "$(pkg_var PKG_NAME ${packages[$i]})" ]]; then
       continue
    fi
    FOUND="1"

    echo "$1 - trying reset to HEAD"
    if git diff --quiet HEAD -- ${packages[$i]}; then
      echo "      --> no reset needed"
    else
      git checkout HEAD -- ${packages[$i]}
      echo "      --> reset done"
    fi
  done

  if [[ -z ${FOUND} ]]; then
    echo "could not find package $1"
  fi
}

# Print the commits between two versions (refs or commit ids) of repository $1.
# Only commits are fetched (no trees and blobs), so this is cheap.
print_changelog() {
  local site=$1 old=$2 new=$3 tmp

  [ -z "$CHANGELOG" ] && return

  tmp=$(mktemp -d)
  if git -C "$tmp" init -q --bare && \
     git -C "$tmp" fetch -q --filter=tree:0 --no-tags "$site" "$old:refs/old" "$new:refs/new" 2>/dev/null; then
    git -C "$tmp" log --no-merges --format='        %h %s' refs/old..refs/new | head -20
  fi
  rm -rf "$tmp"
}

# result of a check, read by update(): status name file version sha
result() {
  echo -e "$1\t$PKG_NAME\t$PKGFILE\t$2\t$3" > "$RESFILE"
}

# check a commit based package for a newer commit on its branch
check_commit() {
  local latest sha url

  if [[ -z ${PKG_BRANCH} ]]; then
     PKG_BRANCH=$(git ls-remote --symref "$PKG_SITE" HEAD | sed -nE 's|^ref: refs/heads/(\S+)\s+HEAD|\1|p')
  fi

  # ask for the exact branch, a grep would also match e.g. "main-old" for "main"
  latest=$(git ls-remote "$PKG_SITE" "refs/heads/${PKG_BRANCH}" | awk -v ref="refs/heads/${PKG_BRANCH}" '$2 == ref { print $1 }')
  if [[ -z "$latest" ]]; then
      echo "   $PKG_NAME - ERROR: branch '${PKG_BRANCH}' not found at $PKG_SITE"
      result failed
      return
  fi

  if [ "$PKG_VERSION" == "$latest" ]; then
      echo "   ## $PKG_NAME - no update available"
      result noupdate
      return
  fi

  download_new "$latest" || return
  print_changelog "$PKG_SITE" "$PKG_VERSION" "$latest"
}

# Check a release tag based package for a newer tag. Only the last number
# is updated automatically (e.g. 1.2.3 -> 1.2.4), newer major/minor
# versions are reported for a manual update.
check_tag() {
  local tags t prefix="" found="" escaped patch_re any_re newest newest_any

  tags=$(git ls-remote --tags --refs "$PKG_SITE" | sed 's|.*refs/tags/||')
  if [[ -z "$tags" ]]; then
      echo "   $PKG_NAME - ERROR: no tags found at $PKG_SITE"
      result failed
      return
  fi

  # tag of the current version, e.g. v1.2.3 for PKG_VERSION 1.2.3
  for t in "$PKG_VERSION" "v$PKG_VERSION" $tags; do
      if [[ "$t" == *"$PKG_VERSION" ]] && [[ ! "${t%$PKG_VERSION}" =~ [0-9] ]] && grep -qxF -- "$t" <<< "$tags"; then
          prefix=${t%$PKG_VERSION}
          found=1
          break
      fi
  done

  if [[ -z "$found" ]]; then
      echo "   $PKG_NAME - tag of version $PKG_VERSION not found, needs manual update"
      result manual
      return
  fi

  escaped=$(sed 's/[][\.*^$()+?{}|]/\\&/g' <<< "$PKG_VERSION")
  patch_re=$(sed -E 's/[0-9]+([^0-9]*)$/[0-9]+\1/' <<< "$escaped")
  any_re=$(sed -E 's/[0-9]+/[0-9]+/g' <<< "$escaped")

  versions_matching() {
      for t in $tags; do
          [[ "$t" == "$prefix"* ]] || continue
          t=${t#$prefix}
          [[ "$t" =~ ^$1$ ]] && echo "$t"
      done | sort -V | tail -1
  }

  newest=$(versions_matching "$patch_re")
  newest_any=$(versions_matching "$any_re")

  # a single number is a major version, don't update it automatically
  if [[ $(grep -oE '[0-9]+' <<< "$PKG_VERSION" | wc -l) -lt 2 ]]; then
      newest=$PKG_VERSION
  fi

  if [[ "$newest" != "$PKG_VERSION" ]] && [[ "$(printf '%s\n' "$PKG_VERSION" "$newest" | sort -V | tail -1)" == "$newest" ]]; then
      download_new "$newest" || return
      print_changelog "$PKG_SITE" "refs/tags/$prefix$PKG_VERSION" "refs/tags/$prefix$newest"
  elif [[ "$newest_any" != "$PKG_VERSION" ]] && [[ "$(printf '%s\n' "$PKG_VERSION" "$newest_any" | sort -V | tail -1)" == "$newest_any" ]]; then
      echo "   $PKG_NAME - found new release $newest_any, needs manual update"
      result manual
  else
      echo "   ## $PKG_NAME - no update available"
      result noupdate
  fi
}

# download the new version $1 and print/store the new values
download_new() {
  local url sha

  echo "$PKG_NAME - found new version"
  url=${PKG_URL//\$\{PKG_VERSION\}/$1}
  if ! sha=$(set -o pipefail; wget -q "${url}" -O- | sha256sum | cut -d " " -f1); then
      echo "   $PKG_NAME - ERROR: download of ${url} failed"
      result failed
      return 1
  fi
  echo "      PKG_VERSION=\"$1\""
  echo "      PKG_SHA256=\"${sha}\""
  result update "$1" "$sha"
}

# check package.mk $1, write the output to $2.out and the result to $2.res
check_package() {
  PKGFILE=$1
  RESFILE=$2.res
  exec > "$2.out" 2>&1

  PKG_NAME=$(pkg_var PKG_NAME $PKGFILE)
  PKG_SITE=$(pkg_var PKG_SITE $PKGFILE)
  PKG_BRANCH=$(pkg_var PKG_BRANCH $PKGFILE)
  PKG_VERSION=$(pkg_var PKG_VERSION $PKGFILE)
  PKG_URL=$(pkg_var PKG_URL $PKGFILE)

  if [[ ! $PKG_SITE =~ github ]] && [[ ! $PKG_SITE =~ gitlab ]] && [[ ! $PKG_SITE =~ codeberg ]]; then
      result skipped
  elif [[ ! "$PKG_URL" == *'${PKG_VERSION}'* ]]; then
      echo "   $PKG_NAME - PKG_URL doesn't use \${PKG_VERSION}, needs manual update"
      result manual
  elif [[ "$PKG_VERSION" =~ ^[0-9a-f]{40}$ ]]; then
      check_commit
  else
      check_tag
  fi
}

# find all package.mk und try to check, if an update exists
# if an updated version exist, update the package if RUN is set
# This currently works only for git repositories
update() {
  local tmp list idx file status name version sha

  packages=($(find packages -name package.mk))

  if [[ -z ${RUN} ]]; then
     echo "Perform a dry run!"
  else
     echo "Try update ..."
  fi

  if [[ -z "$PACKAGE" ]]; then
    echo "Available packages: ${#packages[@]}"
  else
    echo "checking $PACKAGE"
  fi

  PKGARRAY=()
  PKGNAMEARRAY=()
  VERARRAY=()
  SHAARRAY=()
  PKGNAMEARRAYMAN=()
  PKGNAMEARRAYSKIP=()
  PKGNAMEARRAYFAIL=()
  checked=0
  failed=0
  manual=0
  noupdate=0
  skipped=0
  autoupdate=0

  # select the packages, the checks itself run in parallel
  tmp=$(mktemp -d)
  list=()
  for (( i=0; i<${#packages[@]}; i++ )); do
    PKG_NAME=$(pkg_var PKG_NAME ${packages[$i]})

    if [ -n "$PACKAGE" ] && [ ! "$PACKAGE" = "$PKG_NAME" ]; then
        continue
    fi

    if [[ ! -z "$PLUGINSONLY" ]] && [[ ! $PKG_NAME =~ "_vdr-plugin" ]]; then
        continue
    fi
    checked=$((checked + 1))
    list+=( "$i" "${packages[$i]}" )
  done

  xargs_pid=""
  if [ ${#list[@]} -gt 0 ]; then
    printf '%s\n' "${list[@]}" | CHANGELOG=$CHANGELOG xargs -n 2 -P "$JOBS" sh -c '"$0" --check-package "$3" "$1/$2"' "$SELF" "$tmp" &
    xargs_pid=$!
  fi

  # print the results in the original order as soon as they are available
  for (( i=0; i<${#list[@]}; i+=2 )); do
    idx=${list[$i]}
    while [ ! -e "$tmp/$idx.done" ] && kill -0 $xargs_pid 2>/dev/null; do
      sleep 0.1
    done
    cat "$tmp/$idx.out" 2>/dev/null
    IFS=$'\t' read -r status name file version sha < "$tmp/$idx.res" || status=failed

    case $status in
      update)
        PKGARRAY+=( "$file" )
        PKGNAMEARRAY+=( "$name" )
        VERARRAY+=( "$version" )
        SHAARRAY+=( "$sha" )
        autoupdate=$((autoupdate + 1)) ;;
      noupdate)
        noupdate=$((noupdate + 1)) ;;
      manual)
        PKGNAMEARRAYMAN+=( "$name" )
        manual=$((manual + 1)) ;;
      skipped)
        PKGNAMEARRAYSKIP+=( "$name" )
        skipped=$((skipped + 1)) ;;
      *)
        PKGNAMEARRAYFAIL+=( "${name:-${list[$i+1]}}" )
        failed=$((failed + 1)) ;;
    esac
  done
  [ -n "$xargs_pid" ] && wait $xargs_pid
  rm -rf "$tmp"

  # update packages
  if [ -z "$PACKAGE" ]; then
     echo "Auto update possible ($autoupdate):"
  fi
  if [[ -n $RUN ]]; then
     for j in ${!PKGARRAY[@]}; do
         echo "--> replacing PKG_VERSION and PKG_SHA256 for ${PKGNAMEARRAY[$j]}"
         sed -i "s/^PKG_VERSION=.*/PKG_VERSION=\"${VERARRAY[$j]}\"/" ${PKGARRAY[$j]}
         sed -i "s/^PKG_SHA256=.*/PKG_SHA256=\"${SHAARRAY[$j]}\"/" ${PKGARRAY[$j]}
     done
  else
     for j in ${!PKGARRAY[@]}; do
         echo "--> update available for ${PKGNAMEARRAY[$j]} -> ${VERARRAY[$j]} (${SHAARRAY[$j]})"
     done
  fi

  if [ -n "$PACKAGE" ]; then
     if [ $checked -eq 0 ]; then
        echo "could not find package $PACKAGE"
     fi
     return
  fi

  echo "Manual update possible ($manual):"
  for j in ${!PKGNAMEARRAYMAN[@]}; do
      echo "--> manual update available for ${PKGNAMEARRAYMAN[$j]}"
  done

  echo "No update available ($noupdate):"
  echo "Skipped packages ($skipped):"
  for j in ${!PKGNAMEARRAYSKIP[@]}; do
      echo "--> skipped check for ${PKGNAMEARRAYSKIP[$j]}"
  done

  echo "Failed packages ($failed):"
  for j in ${!PKGNAMEARRAYFAIL[@]}; do
      echo "--> check failed for ${PKGNAMEARRAYFAIL[$j]}"
  done
}

# internal: check of a single package, started in parallel by update()
if [[ "$1" == "--check-package" ]]; then
  check_package "$2" "$3"
  touch "$3.done"
  exit 0
fi

cd "$(dirname "$0")"
SELF="$(pwd)/$(basename "$0")"

if [[ "$#" -eq 0 ]]; then
  echo "No parameter passed!"
  usage
fi

RUN="1"
JOBS=8
ACTION=""
PACKAGE=""
PLUGINSONLY=""
CHANGELOG=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a) ACTION=update ;;
        -p) ACTION=update; PLUGINSONLY="1" ;;
        -t) RUN="" ;;
        -s) shift; ACTION=update; PACKAGE=$1
            if [[ -z "$PACKAGE" ]]; then
              echo "ERROR: no PKG_NAME given"
              usage
            fi ;;
        -r) shift; ACTION=reset; PACKAGE=$1 ;;
        -j) shift; JOBS=$1
            if [[ ! "$JOBS" =~ ^[1-9][0-9]*$ ]]; then
              echo "ERROR: -j needs a number"
              usage
            fi ;;
        -c) CHANGELOG="1" ;;
        --help) usage 0 ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift || continue
done

if [[ -z "$ACTION" ]] && [[ -n "$RUN" ]]; then
  echo "ERROR: no action given"
  usage
fi

case $ACTION in
    reset) reset_package "$PACKAGE" ;;
    *) update ;;
esac

exit 0
