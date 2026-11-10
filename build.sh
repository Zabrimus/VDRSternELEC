#!/bin/bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[0;37m'
RESET='\033[0m'

PROGNAME=$0

# all paths are relative to the directory of this script
cd "$(dirname "$0")"
ROOTDIR=$(pwd)

# path to https://github.com/LibreELEC.tv/release-scripts
RELEASESCRIPTDIR="release-scripts"
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
-package <name,name> : Build only the given packages (comma-separated list)
-release <server>  : Create release for update, accessible at <server>
-releaseonly       : Build only the release tar and not all images
-cef               : Include cef binaries into release, otherwise deploy it as an external package
-cebootlabel       : Change CoreELEC bootlabel to value of "-config"
-verbose           : Enable verbose outputs while building LE/CE packages
-nocheckout        : Use the LE/CE directory as it is (no reset, checkout and patches),
                     it must have been prepared before with the same config
-log               : Write all output additionally to logs/<config>-<date>.log
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

  exit ${1:-1}
}

# Run a command of LE/CE without our DISTRO (directory name), LE/CE
# use DISTRO for the name of the distribution. If it's exported (e.g.
# in the Github workflows) it would be inherited.
distro_run() {
  (unset DISTRO; "$@")
}

# Reset submodule $1 and check out $2 (commit, branch or tags/<tag>).
# Fetch only if needed, so known commits can be built offline.
checkout_submodule() {
  local dir=$1 ref=$2

  cd $ROOTDIR
  if [ ! -e $dir/.git ]; then
      git submodule update --init -- $dir
  fi

  cd $dir
  git clean -fd
  git reset --hard

  # branches and tags can move, commits are fetched only if missing
  if [[ ! "$ref" =~ ^[0-9a-f]{7,40}$ ]] || ! git rev-parse -q --verify "${ref}^{commit}" >/dev/null; then
      echo "Fetch $dir"
      git fetch --tags origin
  fi

  if git rev-parse -q --verify "refs/remotes/origin/${ref}" >/dev/null; then
      git checkout --detach "origin/${ref}"
  else
      git checkout --detach "$ref"
  fi
  cd $ROOTDIR
}

checkout() {
  checkout_submodule $DISTRO $SHA
}

checkout_release_script() {
  if [ -z "$RELEASESHA" ]; then
    echo -e "${RED}ERROR: release-scripts SHA not found${RESET}"
    exit 1
  fi
  checkout_submodule $RELEASESCRIPTDIR $RELEASESHA
}

# marker in the LE/CE directory, which config was used to patch it
PATCHED_MARKER=.vdrsternelec-config

# directories with patches and scripts, from generic to specific
patch_dirs() {
    local base
    echo "../patches"
    for base in "../patches/${DISTRO}" "../patches/${DISTRO}.${PATCHDIR}"; do
        echo "${base}"
        echo "${base}/projects/${PROJECT}"
        echo "${base}/projects/${PROJECT}/devices/${DEVICE}"
        echo "${base}/projects/${PROJECT}/devices/${DEVICE}/variants/${VARIANT}"
    done
}

# files matching $2 in directory $1, in a defined order
list_sorted() {
    find "$1" -maxdepth 1 -name "$2" 2>/dev/null | sort -V
}

apply_patches() {
    cd $ROOTDIR
    cd $DISTRO

    if [ "$VERBOSEBUILD" = "true" ]; then
      echo "Apply patch ../patches/01-build-debug.patch.disabled"
      patch -p1 < ../patches/01-build-debug.patch.disabled
    fi

    # Apply patches and sed scripts in ./patches
    for dir in $(patch_dirs); do
        for i in $(list_sorted "$dir" '*.patch'); do
            echo "Apply patch $i"
            patch -p1 < $i
        done
    done

    for dir in $(patch_dirs); do
        for i in $(list_sorted "$dir" '*.sh'); do
            echo "Apply script $i"
            bash $i
        done
    done

    # Copy package patches to LE/CE directory structure
    cd $ROOTDIR
    for i in $(find package_patches/${DISTRO} package_patches/${DISTRO}.${PATCHDIR} -type f 2>/dev/null); do
        # package_patches/<distro>[.<patchdir>]/<path> -> <distro>/<path>
        DEST=${i#package_patches/}
        DEST=${DISTRO}/${DEST#*/}
        if [ ! -d "$(dirname "$DEST")" ]; then
            mkdir -p "$(dirname "$DEST")"
            echo "Create directory $(dirname "$DEST")/"
        fi
        if cp "$i" "$DEST"; then
            echo "Copy $(basename "$i") to $DEST"
        else
            echo "ERROR copying $(basename "$i") to $DEST"
        fi
    done

    if [ "$DISTRO" = "CoreELEC" ] && [ "$CEBOOTLABEL" = "true" ]; then
        for i in $(find CoreELEC/projects/Amlogic-ce/devices -name "*_boot.ini"); do
            echo "sed -i -e \"s/setenv bootlabel \"CoreELEC\"/setenv bootlabel \"$CONFIG\"/\" \"$i\""
            sed -i -e "s/setenv bootlabel \"CoreELEC\"/setenv bootlabel \"$CONFIG\"/" $i
        done
    fi

    echo "$CONFIG" > $DISTRO/$PATCHED_MARKER
}

# -nocheckout: the tree must have been patched for the same config
check_patched() {
  local patched

  patched=$(cat $ROOTDIR/$DISTRO/$PATCHED_MARKER 2>/dev/null || true)
  if [ -z "$patched" ]; then
    echo -e "${RED}ERROR: $DISTRO was not prepared by build.sh, run it once without -nocheckout${RESET}"
    exit 1
  elif [ "$patched" != "$CONFIG" ]; then
    echo -e "${RED}ERROR: $DISTRO was prepared for config '$patched', not '$CONFIG'${RESET}"
    exit 1
  fi
  echo "Use $DISTRO as it is (prepared for $patched)"
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
  if [ ! "${PACKAGE_ONLY}" = "" ]; then
    echo "Building single package, skip addons"
    return
  fi

  cd $ROOTDIR/$DISTRO

  # delete old build artifacts
  rm -Rf target/*

  # addons must be build before the final build is started
  for TMP in $(compgen -e | grep '^ADDON_'); do
    if grep -q ":${TMP}$" ../config/addons.list; then
      echo "Start building addon ${!TMP} ..."

      PROJECT="$PROJECT" \
        DEVICE="$DEVICE" \
        ARCH="$ARCH" \
        BUILD_SUFFIX="$BUILD_SUFFIX" \
        distro_run scripts/create_addon ${!TMP} || echo -e "${RED}Addon ${!TMP} failed to build!${RESET}"

      PROJECT="$PROJECT" \
        DEVICE="$DEVICE" \
        ARCH="$ARCH" \
        BUILD_SUFFIX="$BUILD_SUFFIX" \
        distro_run scripts/install_addon ${!TMP} || echo -e "${RED}Addon ${!TMP} failed to build!${RESET}"
    fi
  done
}

build() {
  cd $ROOTDIR/$DISTRO

  if [ ! "${PACKAGE_ONLY}" = "" ]; then
    for pkg in ${PACKAGE_ONLY//,/ }; do
      echo "Build ${pkg}"
      distro_run scripts/build ${pkg}
    done
  else
    RELEASE_STRING="Start make image"
    if [ "$DORELEASE" = "true" ]; then
      RELEASE_STRING="${RELEASE_STRING} and release it to ${RELEASE_SERVER}"
    fi
    echo "${RELEASE_STRING}"

    if [ "$RELEASE_ONLY" = "true" ]; then
        distro_run make release
    else
        distro_run make image
    fi
  fi
}

set_env() {
  # export project variables
  cd $ROOTDIR/$DISTRO
  BUILD_SUFFIX="$VARIANT"
  echo "Build environment variables:"
  echo "   PROJECT=$PROJECT"
  echo "   DEVICE=$DEVICE"
  echo "   ARCH=$ARCH"
  if [ "${DISTRO}" = "CoreELEC" ] && [ ! -z $SUB_DEVICE ]; then
    # patch option to build only the desired subdevice
    sed -i -e "s#SUBDEVICES=.*\$#SUBDEVICES=\"$SUB_DEVICE\"#" projects/${PROJECT}/devices/${DEVICE}/options
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
  export VDR_OUTPUTDEVICE="$VDR_OUTPUTDEVICE"
  export VDR_INPUTDEVICE="$VDR_INPUTDEVICE"
  export STERN_RELEASE="$STERN_RELEASE"
  export STERN_ADDON="$STERN_ADDON"
  if [ "$DORELEASE" = "true" ]; then
    echo "   BUILD_PERIODIC=nightly"
    export BUILD_PERIODIC="nightly"
  fi

  # resize system partition if we want to include the cef binaries
  export CEF_BINARIES="$CEF_BINARIES"
  if [ "${DISTRO}" = "CoreELEC" ] && [ ! "${CEF_BINARIES}" = "" ]; then
    sed -i -e "s#SYSTEM_SIZE=.*\$#SYSTEM_SIZE=1024#" distributions/CoreELEC/options
    echo "   SYSTEM_SIZE=1024"
  elif [ "${DISTRO}" = "LibreELEC.tv" ] && [ ! "${CEF_BINARIES}" = "" ]; then
    sed -i -e "s#SYSTEM_SIZE=.*\$#SYSTEM_SIZE=1024#" distributions/LibreELEC/options
    echo "   SYSTEM_SIZE=1024"
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
      echo -e "${RED}ERROR: extras: '$i' not found, stopping build${RESET}"
      exit 1
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
      echo -e "${RED}ERROR: addons: '$i' not found, stopping build${RESET}"
      exit 1
    fi
  done
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -config) shift; CONFIG=$1 ;;
        -extra) shift; LIST_EXTRAS="${LIST_EXTRAS:+$LIST_EXTRAS,}$1" ;;
        -addon) shift; LIST_ADDONS="${LIST_ADDONS:+$LIST_ADDONS,}$1" ;;
        -subdevice) shift; SUB_DEVICE=$1 ;;
        -addononly) ADDON_ONLY=true ;;
        -patchonly) PATCH_ONLY=true ;;
        -package) shift; PACKAGE_ONLY=$1 ;;
        -release) shift; RELEASE_SERVER=$1; DORELEASE=true ;;
        -releaseonly) RELEASE_ONLY=true ;;
        -cef) CEF_BINARIES=true ;;
        -cebootlabel) CEBOOTLABEL=true ;;
        -verbose) VERBOSEBUILD=true ;;
        -nocheckout) NO_CHECKOUT=true ;;
        -log) LOG=true ;;
        -help) usage 0 ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift || continue
done


if [ "x$CONFIG" = "x" ]; then
  usage
fi

if [ ! -f config/distro/$CONFIG ]; then
    echo -e "${RED}Config file '$CONFIG' not found${RESET}"
    echo
    usage
fi

. config/versions
echo "Read config $CONFIG"
. config/distro/$CONFIG

# read extras and addons after the config, read_addon needs ARCH
read_extra "$LIST_EXTRAS"
read_addon "$LIST_ADDONS"

if [ ! -d $DISTRO ]; then
  echo -e "${RED}ERROR: Distribution '$DISTRO' cannot be found.${RESET}"
  exit 1
fi

if [ "$DORELEASE" = "true" ] && [ -z "${RELEASE_SERVER}" ]; then
  echo -e "${RED}ERROR: Building a release was triggered, but RELEASE_SERVER is missing. Stopping build!${RESET}"
  exit 1
fi

# check everything possible before the LE/CE directory is reset
if [ -z "$SHA" ]; then
  echo -e "${RED}ERROR: ${DISTRO} SHA not found${RESET}"
  exit 1
fi

if [ "$DORELEASE" = "true" ] && [ -z "$RELEASESHA" ]; then
  echo -e "${RED}ERROR: release-scripts SHA not found${RESET}"
  exit 1
fi

if [ ! "${PATCH_ONLY}" = "true" ] && [ "$(id -u)" = "0" ]; then
  echo -e "${RED}ERROR: LE/CE can't be built as root, use a regular user account${RESET}"
  exit 1
fi

if [ "$NO_CHECKOUT" = "true" ] && [ "$PATCH_ONLY" = "true" ]; then
  echo -e "${RED}ERROR: -nocheckout and -patchonly together do nothing${RESET}"
  exit 1
fi

if [ "$LOG" = "true" ]; then
  mkdir -p logs
  LOGFILE="logs/${CONFIG}-$(date +%Y%m%d-%H%M%S).log"
  echo "Write log to $LOGFILE"
  exec > >(tee -a "$LOGFILE") 2>&1
fi

if [ "$NO_CHECKOUT" = "true" ]; then
  check_patched
else
  echo "Build $SHA on $DISTRO"
  checkout
  apply_patches
fi
prepare_sources
set_env

if [ ! "${PATCH_ONLY}" = "true" ]; then
    if [ "${AUTOREMOVE}" = "yes" ]; then
      cd $ROOTDIR/$DISTRO
      distro_run ../prepare-autoremove
    fi

    build_addons

    if [ ! "${ADDON_ONLY}" = "true" ]; then
      build
    fi

    if [ "$DORELEASE" = "true" ]; then
       checkout_release_script
       cd $ROOTDIR
       if [ -e "$RELEASESCRIPTDIR/releases.py" ]; then
          echo "Prepare Release for $RELEASE_SERVER in $RELEASEDIR"
          mkdir -p $RELEASEDIR
          for i in `find $DISTRO/target -name '*.tar' 2>/dev/null` \
                   `find $DISTRO/target -name '*.tar.sha256' 2>/dev/null` \
                   `find $DISTRO/target -name '*.img.gz' 2>/dev/null` \
                   `find $DISTRO/target -name '*.img.gz.sha256' 2>/dev/null` \
                   `find $DISTRO/target -name '*.tar.gz' 2>/dev/null` \
                   `find $DISTRO/target/addons -name '*.zip' 2>/dev/null`; do
              mv -f $i $RELEASEDIR
          done
          python3 $RELEASESCRIPTDIR/releases.py -i $RELEASEDIR -u $RELEASE_SERVER -o $RELEASEDIR
       fi
    fi
fi
