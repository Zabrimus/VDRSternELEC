#!/bin/bash

# Delete a package build in all supported configuration

set -e

PROGNAME=$0

if [[ "$#" -eq 0 ]]; then
    echo "Package parameter is missing"
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -config) shift; CONFIG=$1 ;;
        *) PACKAGE=$1;;
    esac
    shift || continue
done

if [ -n "$CONFIG" ]; then
    # only clean one config
    . config/distro/$CONFIG

    (cd $DISTRO
     PROJECT=$PROJECT ARCH=$ARCH DEVICE=$DEVICE scripts/clean $PACKAGE || true
    )

else
    # clean all
    for i in $(ls config/distro); do
      echo "DISTRO: $i"
      # source config
      . config/distro/$i

      (cd $DISTRO
        PROJECT=$PROJECT ARCH=$ARCH DEVICE=$DEVICE scripts/clean $PACKAGE || true
      )
    done
fi