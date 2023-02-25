#!/bin/bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[0;37m'
RESET='\033[0m'

PROGNAME=$0

usage() {
  cat << EOF >&2
Usage: $PROGNAME -config <name> [-extras <name,name> -addon <name,name>]
-config : Build the distribution defined in directory config/distro/<name>
-extra  : Build additional plugins / Use optional VDR patches / Use extra from config/extras.list
          (option is followed by a comma-separated list of the available extras below)
-addon  : Build additional addons which will be pre-installed / Use addon from config/addons.list
          (option is followed by a comma-separated list of the available addons below)
-help   : Show this help
EOF
  echo
  echo "Available configs:"
  ls config/distro

  echo
  echo "Available extras:"
  cat config/extras.list | grep -v ^[#] | grep . | cut -d ":" -f 1

  echo
  echo "Available addons:"
  cat config/addons.list | grep -v ^[#] | grep . | cut -d ":" -f 1

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

  # another attempt to really cleanup
  git stash
  git stash clear

  git reset --hard origin/$BRANCH
  git clean -fd

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

  if [ ! "x$VARIANT" = "x" ]; then
    if [ ! "x$BUILD_SUFFIX" = "x" ]; then
      BUILD_SUFFIX="$BUILD_SUFFIX-$VARIANT"
    else
      BUILD_SUFFIX="$VARIANT"
    fi
  fi
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
             `find ../patches/${DISTRO} -maxdepth 1 -name '*.patch' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/patches -name '*.patch' 2>/dev/null` \
             `find ../patches/${DISTRO}/${BRANCH} -name '*.patch' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/variant/${VARIANT}/patches -name '*.patch' 2>/dev/null`; do
        echo "Apply patch $i"
        patch -p1 < $i
    done

    for i in `find ../patches -maxdepth 1 -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO} -maxdepth 1 -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/patches -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO}/${BRANCH} -name '*.sh' 2>/dev/null` \
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

build_addons() {
  cd $ROOTDIR/$DISTRO

  # delete old build artifacts
  rm -Rf target/*

  ADDON_LOCALE=locale

  # addons must be build before the final build is started
  for i in $(env | grep ^ADDON_); do
    TMP=$(echo $i | cut -d "=" -f 1)
    if [ $(grep $TMP$ ../config/addons.list) ]; then

      echo "Start building addon ${!TMP} ..."

      PROJECT="$PROJECT" \
        DEVICE="$DEVICE" \
        ARCH="$ARCH" \
        BUILD_SUFFIX="$BUILD_SUFFIX" \
        scripts/create_addon ${!TMP} || echo -e "${RED}Addon ${!TMP} failed to build!${RESET}"
    fi
  done
}

build() {
  cd $ROOTDIR/$DISTRO

  PROJECT="$PROJECT" \
    DEVICE="$DEVICE" \
    ARCH="$ARCH" \
    BUILD_SUFFIX="$BUILD_SUFFIX" \
    VDR_OUTPUTDEVICE="$VDR_OUTPUTDEVICE" \
    VDR_INPUTDEVICE="$VDR_INPUTDEVICE" \
    make image
}

cleanup() {
  cd $ROOTDIR/$DISTRO

  git reset --hard origin/$BRANCH
}

read_extra() {
  extras=($(echo $1 | tr "," "\n"))
  for i in "${extras[@]}"; do
    extra=($(grep -R ^$i: config/extras.list | grep -v ^[#] | tr ":" "\n"))
    if [ ! "x$extra" = "x" ]; then
      export $(echo ${extra[1]})=y
      echo "extras: use '$i', set environment variable $(env | grep ${extra[1]})"
    else
      echo "extras: '$i' not found"
    fi
  done
}

read_addon() {
  addons=($(echo $1 | tr "," "\n"))
  for i in "${addons[@]}"; do
    addon=($(grep -R ^$i: config/addons.list | grep -v ^[#] | tr ":" "\n"))
    if [ ! "x$addon" = "x" ]; then
      # digital_devices can be build only for x86_64
      if [ "${addon[1]}" = "ADDON_DIGITAL_DEVICES" ] && [ ! "$ARCH" = "x86_64" ]; then
          echo -e "${RED}Addon digital_devices is only possible for ARCH x86_64. Skip build.${RESET}"
          continue
      fi

      export $(echo ${addon[1]})=$(echo ${addon[0]})
      echo "addons: use '$i', set environment variable $(env | grep ${addon[1]})"
    else
      echo "addons: '$i' not found"
    fi
  done
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -config) shift; CONFIG=$1 ;;
        -extra) shift; read_extra $1 ;;
        -addon) shift; read_addon $1 ;;
        -help) shift; usage ;;
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

cleanup
checkout
apply_patches
prepare_sources
build_addons
build
cleanup