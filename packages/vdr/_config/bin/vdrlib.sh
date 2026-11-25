#!/bin/sh

# Replace VDR and its plugins of the image by own builds (opt-in for developers).
#
# If VDR_DEVLIBS=yes is set in /storage/.profile, VDR loads its plugins from
# /storage/.config/vdrlibs. This directory contains a link for every plugin,
# by default to the plugin in the image (/usr/local/lib/vdr). A link can be
# changed to point to an own build, it is kept on updates. A link "vdr" in
# this directory replaces /usr/local/bin/vdr. Libraries in
# /storage/.config/vdrlibs/lib are preferred to the ones of the image.

IMAGE_DIR="/usr/local/lib/vdr"
PLUGIN_DIR="/storage/.config/vdrlibs"
PROFILE="/storage/.profile"

usage() {
  cat << EOF >&2
Usage: $0 enable|disable|sync|list|set <plugin> <file>|reset <plugin>|all

enable          : load the VDR plugins via $PLUGIN_DIR
disable         : load the VDR plugins from the image again
sync            : create missing links, remove dead links into the image
                  (done by start_vdr.sh on every start)
list            : show all plugins and where they point to
set <plugin> <file>
                : use <file> for <plugin>, e.g. set web /storage/build/libvdr-web.so.8,
                  "vdr" as <plugin> replaces VDR itself
reset <plugin>|all
                : use the plugin (or VDR) of the image again
EOF
  exit 1
}

# API version of the plugins in the image, e.g. 8
image_api() {
  for f in ${IMAGE_DIR}/libvdr-*.so.*; do
    [ -e "$f" ] && echo "${f##*.so.}" && return 0
  done
  return 1
}

# API version of the VDR binary $1, empty if unknown
vdr_api() {
  LD_LIBRARY_PATH="${PLUGIN_DIR}/lib:/usr/local/lib" "$1" --version 2>/dev/null | \
    sed -n 's#^vdr ([^/]*/\([^)]*\)).*#\1#p' | head -1
}

# file name of plugin $1 in the image, e.g. libvdr-web.so.8
plugin_file() {
  for f in ${IMAGE_DIR}/libvdr-$1.so.*; do
    [ -e "$f" ] && echo "${f##*/}" && return 0
  done
  return 1
}

sync() {
  mkdir -p ${PLUGIN_DIR}/lib

  for f in ${IMAGE_DIR}/libvdr-*.so.*; do
    [ -e "$f" ] || continue
    link="${PLUGIN_DIR}/${f##*/}"
    if [ ! -e "$link" ] && [ ! -L "$link" ]; then
      ln -s "$f" "$link"
    fi
  done

  # dead links into the image belong to removed plugins or an old API version
  for link in ${PLUGIN_DIR}/libvdr-*.so.*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      ${IMAGE_DIR}/*) [ -e "$link" ] || rm -f "$link";;
    esac
  done
}

set_profile() {
  touch ${PROFILE}
  sed -i -e "/^VDR_DEVLIBS=.*$/d" ${PROFILE}
  echo "VDR_DEVLIBS=$1" >> ${PROFILE}
}

case "$1" in
  enable)
    set_profile yes
    sync
    echo "VDR loads its plugins from ${PLUGIN_DIR} after the next restart of VDR"
    ;;
  disable)
    set_profile no
    echo "VDR loads its plugins from ${IMAGE_DIR} after the next restart of VDR"
    ;;
  sync)
    sync
    ;;
  list)
    if [ -L "${PLUGIN_DIR}/vdr" ] || [ -e "${PLUGIN_DIR}/vdr" ]; then
      state="$(readlink "${PLUGIN_DIR}/vdr")"
      [ -x "${PLUGIN_DIR}/vdr" ] || state="$state (missing, VDR of the image is used!)"
      printf "%-24s %-6s %s\n" "vdr" "$(vdr_api "${PLUGIN_DIR}/vdr")" "$state"
    fi
    for link in ${PLUGIN_DIR}/libvdr-*.so.*; do
      [ -L "$link" ] || [ -e "$link" ] || continue
      name="${link##*/libvdr-}"
      name="${name%%.so.*}"
      target="$(readlink "$link")"
      case "$target" in
        ${IMAGE_DIR}/*) state="image";;
        "") state="file in ${PLUGIN_DIR}";;
        *) state="$target";;
      esac
      [ -e "$link" ] || state="$state (missing!)"
      # an own build for an old API version isn't loaded anymore
      image=$(plugin_file "$name") && [ "$image" != "${link##*/}" ] && \
        state="$state (not used, VDR expects $image)"
      printf "%-24s %-6s %s\n" "$name" "${link##*.so.}" "$state"
    done
    ;;
  set)
    [ -n "$2" ] && [ -n "$3" ] || usage
    if [ ! -e "$3" ]; then
      echo "$3 doesn't exist" >&2
      exit 1
    fi
    # the link has to point to an absolute path
    set -- "$1" "$2" "$(readlink -f "$3")"
    if [ "$2" = "vdr" ]; then
      mkdir -p ${PLUGIN_DIR}
      ln -sfn "$3" "${PLUGIN_DIR}/vdr"
      api=$(vdr_api "$3")
      expected=$(image_api)
      if [ -n "$api" ] && [ -n "$expected" ] && [ "$api" != "$expected" ]; then
        echo "WARNING: $3 has API version $api, the plugins of the image have $expected."
        echo "         All enabled plugins have to be replaced by own builds for API $api."
      fi
      echo "vdr -> $3, restart VDR to use it"
      exit 0
    fi
    file=$(plugin_file "$2") || file="${3##*/}"
    mkdir -p ${PLUGIN_DIR}
    ln -sfn "$3" "${PLUGIN_DIR}/${file}"
    echo "${file} -> $3, restart VDR to use it"
    ;;
  reset)
    [ -n "$2" ] || usage
    if [ "$2" = "all" ]; then
      rm -f ${PLUGIN_DIR}/libvdr-*.so.* ${PLUGIN_DIR}/vdr
    elif [ "$2" = "vdr" ]; then
      rm -f ${PLUGIN_DIR}/vdr
    else
      rm -f ${PLUGIN_DIR}/libvdr-$2.so.*
    fi
    sync
    echo "restart VDR to use the plugins of the image"
    ;;
  *)
    usage
    ;;
esac
