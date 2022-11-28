#!/bin/bash

set -e

# dummy method
get_pkg_directory() {
  echo "H"
}

# find all package.mk und try to check, if an update exists
# This currently works only for git repositories

packages=($(find packages -name package.mk))

echo "Count: ${#packages[@]}"

for (( i=0; i<${#packages[@]}; i++ )); do
  PKG_BRANCH=""
  source ${packages[$i]}
  if [[ $PKG_SITE =~ github ]] || [[ $PKG_SITE =~ gitlab ]]; then
    if [[ -z $PKG_BRANCH ]]; then
      LATEST=$(git ls-remote -h $PKG_SITE | head -1 | awk -F' '  '{ print $1 }')
    else
      LATEST=$(git ls-remote -h $PKG_SITE | grep $PKG_BRANCH | head -1 | awk -F' '  '{ print $1 }')
    fi

    if [ ! "$PKG_VERSION" == "$LATEST" ]; then
        echo "${packages[$i]}, $PKG_SITE  --> Latest version $LATEST, current version $PKG_VERSION"
    fi
  fi
done