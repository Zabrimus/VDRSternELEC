#!/bin/bash

# dummy methods
get_pkg_directory() {
  echo "H"
}

get_build_dir() {
  echo "B"
}

get_install_dir() {
  echo "I"
}

target_has_feature() {
  return 1
}

PROGNAME=$0
RUN=""
PACKAGE=""

usage() {
  cat << EOF >&2

Usage: $PROGNAME [-a|-t|-s PKG_NAME|-r PKG_NAME]

Options
-a          : Check and update all packages
-t          : Do a dry run for updating all packages
-s PKG_NAME : Check and update single package PKG_NAME
-r PKG_NAME : reset package PKG_NAME to HEAD
--help      : Show this help
EOF
  exit 1
}

reset_package() {
  if [[ -z "$1" ]]; then
    echo "ERROR: no PKG_NAME given"
    usage
    exit 1
  fi

  FOUND=""
  packages=($(find packages -name package.mk))

  for (( i=0; i<${#packages[@]}; i++ )); do
    source ${packages[$i]}
    if [[ "$1" != "$PKG_NAME" ]]; then
       continue
    fi
    FOUND="1"

    echo "$PKG_NAME - trying reset to HEAD"
    SUCCESS="$(git checkout HEAD ${packages[$i]} 2>&1 | grep '^[^0]')"

    if [[ -z ${SUCCESS} ]]; then
      echo "      --> no reset needed"
    else
      echo "      --> reset done"
    fi
  done

  if [[ -z ${FOUND} ]]; then
    echo "could not find package $1"
  fi
}

# find all package.mk und try to check, if an update exists
# if an updated version exist, update the package if forced with "-u"
# This currently works only for git repositories
update() {
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
  VERARRAY=()
  SHAARRAY=()
  PKGNAMEARRAYMAN=()
  PKGNAMEARRAYSKIP=()
  manual=0
  skipped=0
  autoupdate=0

  for (( i=0; i<${#packages[@]}; i++ )); do
    PKG_BRANCH=""
    PKG_BRANCH_DEFAULT=""

    PKG_NAME=$(grep -e "^PKG_NAME" ${packages[$i]} | sed s/^PKG_NAME=\"// | sed s/\"$// )
    PKG_SITE=$(grep -e "^PKG_SITE" ${packages[$i]} | sed s/^PKG_SITE=\"// | sed s/\"$// )
    PKG_BRANCH=$(grep -e "^PKG_BRANCH" ${packages[$i]} | sed s/^PKG_BRANCH=\"// | sed s/\"$// )
    PKG_VERSION=$(grep -e "^PKG_VERSION" ${packages[$i]} | sed s/^PKG_VERSION=\"// | sed s/\"$// )
    PKG_URL=$(grep -e "^PKG_URL" ${packages[$i]} | sed s/^PKG_URL=\"// | sed s/\"$// )
    PKG_BRANCH=$(grep -e "^PKG_BRANCH" ${packages[$i]} | sed s/^PKG_BRANCH=\"// | sed s/\"$// )

    if [ -n "$PACKAGE" ] && [ ! "$PACKAGE" = "$PKG_NAME" ]; then
        continue
    fi

    if [[ ! -z "$PLUGINSONLY" ]] && [[ ! $PKG_NAME =~ "_vdr-plugin" ]]; then
        continue
    fi

    if [[ $PKG_SITE =~ github ]] || [[ $PKG_SITE =~ gitlab ]]; then
      COUNT_BRANCHES=$(git ls-remote -h $PKG_SITE | wc -l)

      PKG_BRANCH_DEFAULT=`git ls-remote --symref "$PKG_SITE" HEAD | sed -nE 's|^ref: refs/heads/(\S+)\s+HEAD|\1|p'`
      if [[ -z ${PKG_BRANCH} ]]; then
         PKG_BRANCH=$PKG_BRANCH_DEFAULT
      fi

      LATEST=$(git ls-remote -h $PKG_SITE | grep $PKG_BRANCH | head -1 | awk -F' '  '{ print $1 }')
      if [ ! "$PKG_VERSION" == "$LATEST" ]; then
          if [[ -z `grep -oE "^PKG_VERSION=\"([a-f]|[0-9]){40}\"" ${packages[$i]}` ]]; then
              echo "   $PKG_NAME - found new version, but packages version is a release tag, skip updating"
              PKGNAMEARRAYMAN+=( ${PKG_NAME} )
              manual=$((manual + 1))
              continue
          fi

          echo "$PKG_NAME - found new version"
          NEUE_URL=$( echo ${PKG_URL} | sed -e s/\$\{PKG_VERSION\}/${LATEST}/g )
          SHA=$(wget -q "${NEUE_URL}" -O- | sha256sum | cut -d " " -f1)
          echo "      PKG_VERSION=\"$LATEST\""
          echo "      PKG_SHA256=\"${SHA}\""

          # fill array with updateable packages
          PKGARRAY+=( ${packages[$i]} )
          PKGNAMEARRAY+=( ${PKG_NAME} )
          VERARRAY+=( ${LATEST} )
          SHAARRAY+=( ${SHA} )
          autoupdate=$((autoupdate + 1))
      else
          echo "   ## $PKG_NAME - no update available"
          noupdate=$((noupdate + 1))
      fi
    else
      PKGNAMEARRAYSKIP+=( ${PKG_NAME} )
      skipped=$((skipped + 1))
    fi
  done

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
     exit 0
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
}

try_update() {
  update
}

update_all() {
  RUN="1"
  update
}

update_plugins_only() {
  RUN="1"
  PLUGINSONLY="1"
  update
}

update_package() {
  if [[ -z "$1" ]]; then
    echo "ERROR: no PKG_NAME given"
    usage
    exit 1
  fi

  RUN="1"
  PACKAGE=$1
  update
}

if [[ "$#" -eq 0 ]]; then
  echo "No parameter passed!"
  usage
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a) update_all ;;
        -p) update_plugins_only ;;
        -t) try_update ;;
        -s) shift; update_package $1 ;;
        -r) shift; reset_package $1 ;;
        --help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift || continue
done

exit 0
