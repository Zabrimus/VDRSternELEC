#!/bin/bash

# Delete a package build in all supported configuration

set -e

PROGNAME=$0

if [[ "$#" -ew 0 ]]; then
    echo "Package parameter is missing"
fi

for i in $(ls config/distro); do
  # source config
  . config/distro/$i

  (cd $DISTRO
    PROJECT=$PROJECT ARCH=$ARCH DEVICE=$DEVICE scripts/clean $1
  )
done
