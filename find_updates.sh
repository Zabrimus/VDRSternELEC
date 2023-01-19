#!/bin/bash

# dummy methods
get_pkg_directory() {
  echo "H"
}

target_has_feature() {
  return 1
}

PROGNAME=$0
RUN=""

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-u]
-u      : Update the packages, otherwise do just a test run
--help  : Show this help
EOF
  exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u) RUN="1" ;;
        --help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift || continue
done

# find all package.mk und try to check, if an update exists
# if an updated version exist, update the package if forced with "-u"
# This currently works only for git repositories

packages=($(find packages -name package.mk))

if [[ -z ${RUN} ]]; then
   echo "This is just a dry run!"
else
   echo "Packages will be updated!"
fi

echo "Count: ${#packages[@]}"

for (( i=0; i<${#packages[@]}; i++ )); do
  PKG_BRANCH=""
  PKG_BRANCH_DEFAULT=""
  source ${packages[$i]}
  if [[ $PKG_SITE =~ github ]] || [[ $PKG_SITE =~ gitlab ]]; then
    COUNT_BRANCHES=$(git ls-remote -h $PKG_SITE | wc -l)
    PKG_BRANCH_DEFAULT=`git ls-remote --symref "$PKG_SITE" HEAD | sed -nE 's|^ref: refs/heads/(\S+)\s+HEAD|\1|p'`
    if [[ -z ${PKG_BRANCH} ]]; then
       PKG_BRANCH=$PKG_BRANCH_DEFAULT
    fi
    if [[ -z ${PKG_BRANCH} ]] && [[ ${COUNT_BRANCHES} -ge 2 ]]; then
       echo "Warning: ${PKG_SITE} -> PKG_BRANCH not found, but there exists multiple branches"
    fi

    if [[ -z $PKG_BRANCH ]]; then
      LATEST=$(git ls-remote -h $PKG_SITE | head -1 | awk -F' '  '{ print $1 }')
    else
      LATEST=$(git ls-remote -h $PKG_SITE | grep $PKG_BRANCH | head -1 | awk -F' '  '{ print $1 }')
    fi

    if [[ -z $LATEST ]]; then
        continue
    fi


    if [ ! "$PKG_VERSION" == "$LATEST" ]; then
        echo "$PKG_NAME - found new version"
        echo "      PKG_VERSION=\"$LATEST\""

        NEUE_URL=$( echo $PKG_URL | sed -e s/${PKG_VERSION}/${LATEST}/g )
        SHA=$(wget -q "${NEUE_URL}" -O- | sha256sum | cut -d " " -f1)
        echo "      PKG_SHA256=\"${SHA}\""

        if [[ -z `grep -oE "^PKG_VERSION=\"([a-f]|[0-9]){40}\"" ${packages[$i]}` ]]; then
            echo "      --> packages version is a release tag, skip updating"
            continue
        fi

        if [[ -n $RUN ]]; then
            echo "      --> replacing PKG_VERSION and PKG_SHA256 in ${packages[$i]}"
            sed -i "s/^PKG_VERSION=.*/PKG_VERSION=\"${LATEST}\"/" ${packages[$i]}
            sed -i "s/^PKG_SHA256=.*/PKG_SHA256=\"${SHA}\"/" ${packages[$i]}
        fi
    else
        echo "$PKG_NAME - no update available"
    fi
  fi
done
