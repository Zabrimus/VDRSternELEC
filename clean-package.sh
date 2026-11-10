#!/bin/bash

# Delete the build of packages in all existing LE/CE build directories

set -e

PROGNAME=$0

cd "$(dirname "$0")"

usage() {
    cat << EOF >&2
Usage: $PROGNAME [-config <name>] [-sources] <package> [<package> ...]

-config <name> : Only clean the build directory of config/distro/<name>
-sources       : Delete the downloaded sources of the packages too
EOF
    exit ${1:-1}
}

PACKAGES=()
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -config) shift; CONFIG=$1 ;;
        -sources) SOURCES=true ;;
        -help|--help) usage 0 ;;
        -*) echo "Unknown parameter passed: $1"; usage ;;
        *) PACKAGES+=( "$1" ) ;;
    esac
    shift || continue
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
    echo "Package parameter is missing"
    usage
fi

if [ -n "$CONFIG" ] && [ ! -f "config/distro/$CONFIG" ]; then
    echo "Config file '$CONFIG' not found"
    exit 1
fi

# major version of the checked out LE/CE in directory $1
os_major() {
    (. "$1/distributions/${1%.tv}/version" 2>/dev/null
     echo "${OS_MAJOR:-${OS_VERSION%%.*}}")
}

# Only existing build directories are cleaned, LE/CE would create missing
# ones. Each has a .build.conf with PROJECT, DEVICE, ARCH and BUILD_SUFFIX.
for distro in LibreELEC.tv CoreELEC; do
    [ -x "$distro/scripts/clean" ] || continue
    major=$(os_major $distro)

    for conf in "$distro"/build.*/.build.conf; do
        [ -f "$conf" ] || continue
        dir=$(dirname "$conf")
        echo "BUILD: $dir"

        (. "$conf"

         if [ -n "$CONFIG" ]; then
             b_arch=$ARCH b_device=${DEVICE:-$PROJECT} b_suffix=$BUILD_SUFFIX
             if ! (. config/distro/$CONFIG
                   [ "$DISTRO" = "$distro" ] && [ "$ARCH" = "$b_arch" ] && \
                   [ "${DEVICE:-$PROJECT}" = "$b_device" ] && [ "$VARIANT" = "$b_suffix" ]); then
                 echo "   not used by config $CONFIG, skip"
                 exit 0
             fi
         fi

         # LE/CE compute the build directory of the checked out version
         if [[ ! "$(basename "$dir")" =~ \.${ARCH}-${major}([.-]|$) ]]; then
             echo "   built with another $distro version, skip"
             exit 0
         fi

         cd "$distro"
         # LE/CE use DISTRO themselves
         unset DISTRO
         for pkg in "${PACKAGES[@]}"; do
             scripts/clean "$pkg" || true
         done
        )
    done
done

if [ "$SOURCES" = "true" ]; then
    # build.sh links the sources of LE and CE to ./sources
    for pkg in "${PACKAGES[@]}"; do
        if [ -d "sources/${pkg%%:*}" ]; then
            echo "Delete sources/${pkg%%:*}"
            rm -rf "sources/${pkg%%:*}"
        fi
    done
fi
