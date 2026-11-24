#!/bin/sh

set -e

CONF_DIR="/storage/.config/vdropt"
BIN_DIR="/usr/local/bin"
LIB_DIR="/usr/local/lib"
LD_PRELOAD_MALI="XXLDPRELOADMALIXX"

read_plugin_configuration () {
  param=`cat ${CONF_DIR}/conf.d/$1.conf  | sed "s/#.*$//g ; s/^#$//g ; s/ *$//g" | tr '\n' ' ' | sed  "s/\[/-P \\'/ ; s/\]// ; s/ *$/\'/"`
  echo "$param"
}

read_vdr_configuration () {
  param=`cat ${CONF_DIR}/conf.d/vdr.conf | sed "s/#.*$//g ; s/^#$//g ; s/ *$//g" | tr '\n' ' ' | sed 's/\[vdr\]//'`
  echo "$param"
}

# start upgrade
${BIN_DIR}/vdrsternupgrade.sh || true

# settings, e.g. VDR_LD_PRELOAD and VDR_DEVLIBS
if [ -f /storage/.profile ]; then
  . /storage/.profile
fi

# optionally load the plugins via links in /storage, see vdrlib.sh
PLUGIN_ARG=""
DEVLIB_PATH=""
VDR_DIR="${BIN_DIR}"
if [ "$VDR_DEVLIBS" = "yes" ]; then
  ${BIN_DIR}/vdrlib.sh sync
  PLUGIN_ARG="-L /storage/.config/vdrlibs"
  DEVLIB_PATH="/storage/.config/vdrlibs/lib:"
  # own build of VDR itself (vdrlib.sh set vdr)
  if [ -x /storage/.config/vdrlibs/vdr ]; then
    VDR_DIR="/storage/.config/vdrlibs"
  fi
fi

arg="vdr $PLUGIN_ARG $(read_vdr_configuration)"

# read VDR plugin start parameters, one plugin per line, # starts a comment
while read -r line || [ -n "$line" ]; do
  set -- ${line%%#*}
  [ -n "$1" ] || continue
  pluginarg="$(read_plugin_configuration $1)"
  arg="$arg $pluginarg"
done < ${CONF_DIR}/enabled_plugins


# kill splash image (CoreELEC)
killall splash-image || true
/usr/local/bin/ClearOSD.sh || true

# needed for locale / OSD language
export LOCPATH=/storage/.kodi/addons/service.locale/locpath

# VFD: show clock
if [ -e /tmp/openvfd_service ]; then
  echo "" > /tmp/openvfd_service
fi

# really start VDR
if [ -z "$VDR_LD_PRELOAD" ]; then
   sh -c "LD_PRELOAD=$LD_PRELOAD_MALI LD_LIBRARY_PATH=$DEVLIB_PATH$LIB_DIR:$LIB_DIR/vdr:$LD_LIBRARY_PATH ${VDR_DIR}/$arg"
else
   sh -c "LD_PRELOAD=\"$LD_PRELOAD_MALI:$VDR_LD_PRELOAD\" LD_LIBRARY_PATH=$DEVLIB_PATH$LIB_DIR:$LIB_DIR/vdr:$LD_LIBRARY_PATH ${VDR_DIR}/$arg"
fi
