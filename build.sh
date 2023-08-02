#!/bin/bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[0;37m'
RESET='\033[0m'

PROGNAME=$0

ROOTDIR=`pwd`

# update server address - needs to be changed!
# this is the kodi update channel address
RELEASE_SERVER=""
# path to https://github.com/LibreELEC.tv/release-scripts
RELEASESCRIPTDIR="$ROOTDIR/../release-scripts"
# releases directory
RELEASEDIR="$ROOTDIR/releases"

usage() {
  cat << EOF >&2
Usage: $PROGNAME -config <name> [Options]
-config            : Build the distribution defined in directory config/distro/<name> (mandatory)

Options:
-extra <name,name> : Build additional plugins / Use optional VDR patches / Use extra from config/extras.list
                     (option is followed by a comma-separated list of the available extras below)
-addon <name,name> : Build additional addons which will be pre-installed / Use addon from config/addons.list
                     (option is followed by a comma-separated list of the available addons below)
-subdevice         : Build only images for the desired subdevice. This speeds up building images.
-addononly         : Build only the desired addons
-patchonly         : Only apply patches and build nothing
-package <name>    : Build a single package
-release           : Create release for update
-help              : Show this help
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

  if [ ! -f $DISTRO/.git ]; then
      git submodule update --init -- $DISTRO
  fi

  cd $DISTRO
  git clean -fd
  git reset --hard

  cd ..
  git submodule update --recursive --remote $DISTRO
  BUILD_SUFFIX=

  cd $DISTRO
  # Checkout defined commit
  if [ ! "x$SHA" = "x" ]; then
    git checkout $SHA
  else
    echo "SHA not found"
    exit 1;
  fi

  if [ ! "x$VARIANT" = "x" ]; then
    BUILD_SUFFIX="$VARIANT"
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
             `find ../patches/${DISTRO}/${PATCHDIR} -name '*.patch' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/variant/${VARIANT}/patches -name '*.patch' 2>/dev/null`; do
        echo "Apply patch $i"
        patch -p1 < $i
    done

    for i in `find ../patches -maxdepth 1 -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO} -maxdepth 1 -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO}/projects/${PROJECT}/devices/${DEVICE}/patches -name '*.sh' 2>/dev/null` \
             `find ../patches/${DISTRO}/${PATCHDIR} -name '*.sh' 2>/dev/null` \
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
  echo "Build environment variables:"
  echo "   PROJECT=$PROJECT"
  echo "   DEVICE=$DEVICE"
  echo "   ARCH=$ARCH"
  if [ "${DISTRO}" = "CoreELEC" ] && [ ! -z $SUB_DEVICE ]; then
    # patch option to build only the desired subdevice
    sed -i -e "s#SUBDEVICES=.*\$#SUBDEVICES=\"$SUB_DEVICE\"#" projects/Amlogic-ce/devices/Amlogic-ng/options
    echo "   SUBDEVICES=${SUB_DEVICE}"
  elif [ "${DISTRO}" = "LibreELEC.tv" ] && [ ! -z $SUB_DEVICE ]; then
    export UBOOT_SYSTEM="${SUB_DEVICE}"
    echo "   UBOOT_SYSTEM=${SUB_DEVICE}"
  fi
  echo "   BUILD_SUFFIX=$BUILD_SUFFIX"
  echo "   VDR_OUTPUTDEVICE=$VDR_OUTPUTDEVICE"
  echo "   VDR_INPUTDEVICE=$VDR_INPUTDEVICE"
  export PROJECT="$PROJECT"
  export DEVICE="$DEVICE"
  export ARCH="$ARCH"
  export BUILD_SUFFIX="$BUILD_SUFFIX"
  if [ -e "$RELEASESCRIPTDIR/releases.py" ] && [ "$DORELEASE" == "true" ]; then
    export BUILD_PERIODIC="nightly"
    echo "   BUILD_PERIODIC=nightly"
  fi
  export VDR_OUTPUTDEVICE="$VDR_OUTPUTDEVICE"
  export VDR_INPUTDEVICE="$VDR_INPUTDEVICE"

  if [ ! "${PACKAGE_ONLY}" = "" ]; then
    echo "Build ${PACKAGE_ONLY}"
    scripts/build ${PACKAGE_ONLY}
  else
    echo "Start make image"
    make image
  fi
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
        -subdevice) shift; SUB_DEVICE=$1 ;;
        -addononly) shift; ADDON_ONLY=true ;;
        -patchonly) shift; PATCH_ONLY=true ;;
        -package) shift; PACKAGE_ONLY=$1 ;;
        -release) shift; DORELEASE=true ;;
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

. config/versions
echo "Read config $CONFIG"
. config/distro/$CONFIG

echo "Build $SHA on $DISTRO"

checkout
apply_patches
prepare_sources

if [ ! "${PATCH_ONLY}" = "true" ]; then
    build_addons

    if [ ! "${ADDON_ONLY}" = "true" ]; then
      build
    fi

    if [ -e "$RELEASESCRIPTDIR/releases.py" ] && [ "$DORELEASE" == "true" ]; then
       echo "Prepare Release for $RELEASE_SERVER in $RELEASEDIR"
       mkdir -p $RELEASEDIR
       for i in `find $DISTRO/target -name '*.tar' 2>/dev/null` \
                `find $DISTRO/target -name '*.tar.sha256' 2>/dev/null` \
                `find $DISTRO/target -name '*.img.gz' 2>/dev/null` \
                `find $DISTRO/target -name '*.img.gz.sha256' 2>/dev/null`; do
           mv -f $i $RELEASEDIR
       done
       python3 $RELEASESCRIPTDIR/releases.py -i $RELEASEDIR -u $RELEASE_SERVER -o $RELEASEDIR
    fi
fi
