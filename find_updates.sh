#!/bin/bash

set -e

# dummy methods
get_pkg_directory() {
  echo "H"
}

target_has_feature() {
  return 1
}

# find all package.mk und try to check, if an update exists
# This currently works only for git repositories

packages=($(find packages -name package.mk))

echo "Count: ${#packages[@]}"

for (( i=0; i<${#packages[@]}; i++ )); do
  PKG_BRANCH=""
  source ${packages[$i]}
  if [[ $PKG_SITE =~ github ]] || [[ $PKG_SITE =~ gitlab ]]; then
    COUNT_BRANCHES=$(git ls-remote -h $PKG_SITE | wc -l)
    if [[ -z ${PKG_BRANCH} ]] && [[ ${COUNT_BRANCHES} -ge 2 ]]; then
       echo "Warning: ${PKG_SITE} -> PKG_BRANCH not found, but there exists multiple branches"
    fi

    if [[ -z $PKG_BRANCH ]]; then
      LATEST=$(git ls-remote -h $PKG_SITE | head -1 | awk -F' '  '{ print $1 }')
    else
      LATEST=$(git ls-remote -h $PKG_SITE | grep $PKG_BRANCH | head -1 | awk -F' '  '{ print $1 }')
    fi

    if [ ! "$PKG_VERSION" == "$LATEST" ]; then
        echo "${packages[$i]}, $PKG_SITE  --> Latest version $LATEST, current version $PKG_VERSION"

        NEUE_URL=$( echo $PKG_URL | sed -e s/${PKG_VERSION}/${LATEST}/g )
        SHA=$(wget -q "${NEUE_URL}" -O- | sha256sum)
        echo "SHA256sum = ${SHA}"
    fi
  fi
done