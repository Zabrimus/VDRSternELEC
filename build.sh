#!/bin/bash

set -e

PROGNAME=$0

usage() {
  cat << EOF >&2
Usage: $PROGNAME -config <name> -extras <name>
-config : Build the distribution defined in directory config/distro/<name>.
-extra  : Build additional plugins / Use optional VDR patches. Use extra config/extras/<name>
          Multiple -extra are possible.
EOF
  echo
  echo "Available configs:"
  ls config/distro

  echo
  echo "Available extras:"
  ls config/extras

  echo

  exit 1
}

checkout() {
  cd $ROOTDIR

  if [ ! -d $DISTRO ]; then
     echo "Distribution '$DISTRO' cannot be found."
     exit 1
  fi

  git submodule update --init -- $DISTRO || true

  cd $DISTRO
  git reset --hard

  if [ ! "x$TAG" = "x" ]; then
    git checkout tags/$TAG
    BUILD_SUFFIX=$TAG
  elif [ ! "x$BRANCH" = "x" ]; then
    git checkout $BRANCH
    git pull --all
    BUILD_SUFFIX=
  elif [ ! "x$REVISION" = "x" ]; then
    git checkout $REVISION
    BUILD_SUFFIX=$REVISION
  else
    echo "No TAG, BRANCH or REVISION found"
    exit 1;
  fi;
}

apply_patches() {
    cd $ROOTDIR

    if [ ! -d $DISTRO ]; then
       echo "Distribution '$DISTRO' cannot be found."
       exit 1
    fi

    cd $DISTRO

    # Apply patches and sed scripts in ./patches
    for i in `find ../patches -maxdepth 1 -name '*.patch' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/patches -name '*.patch' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/variant/${VARIANT}/patches -name '*.patch' 2>/dev/null`; do
        echo "Apply patch $i"
        patch -p1 < $i
    done

    for i in `find ../patches -maxdepth 1 -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/patches -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/variant/${VARIANT}/patches -name '*.sh' 2>/dev/null`; do
        echo "Apply script $i"
        bash $i
    done

    # Copy package patches to LE/CE directory structure
    if [ -d ../package_patches/$DISTRO ]; then
      cp -r ../package_patches/$DISTRO/* .
    fi
}

prepare_sources() {
  cd $ROOTDIR

  if [ ! -d sources ]; then
      mkdir sources
  fi

  if [ ! -d $DISTRO/sources ]; then
     cd $DISTRO
     ln -s ../sources sources
  fi
}

build() {
  cd $ROOTDIR/$DISTRO

  # delete old build artifacts
  rm -f target/*

  PROJECT="$PROJECT" \
    DEVICE="$DEVICE" \
    ARCH="$ARCH" \
    BUILD_SUFFIX="$BUILD_SUFFIX" \
    EASYVDR="$EASYVDR" \
    DYNAMITE="$DYNAMITE" \
    ZAPCOCKPIT="$ZAPCOCKPIT" \
    PERMASHIFT="$PERMASHIFT" \
    VDR_OUTPUTDEVICE="$VDR_OUTPUTDEVICE" \
    VDR_INPUTDEVICE="$VDR_INPUTDEVICE" \
    DIRECTFB2="${DIRECTFB2}" \
    DIRECTFB2SAMPLES="${DIRECTFB2SAMPLES}" \
    make image
}

cleanup() {
  cd $ROOTDIR/$DISTRO

  git reset --hard
}

read_extra() {
  if [ ! "x$1" = "x" ] && [ ! -f config/extras/$1 ]; then
    echo "extra '$1' not found"
    echo
    usage
  fi

  echo "Read Extra $1"
  . config/extras/$1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -config) shift; CONFIG=$1 ;;
        -extra) shift; read_extra $1 ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift || continue
done


if [ "x$CONFIG" = "x" ]; then
  usage
fi

if [ ! -f config/distro/$CONFIG ]; then
    echo "Config file '$CONFIG' not found"
    echo
    usage
fi

ROOTDIR=`pwd`

echo "Read config $CONFIG"
. config/distro/$CONFIG

checkout
apply_patches
prepare_sources
build
cleanup