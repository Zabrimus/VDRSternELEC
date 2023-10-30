#!/bin/sh

set -e

CONF_DIR="/storage/.config/vdropt"
BIN_DIR="/usr/local/bin"
LIB_DIR="/usr/local/lib"
LD_PRELOAD_MALI="XXLDPRELOADMALIXX"

read_vdr_configuration () {
  param=`cat ${CONF_DIR}/conf.d/vdr.conf | sed "s/#.*$//g ; s/^#$//g ; s/ *$//g" | tr '\n' ' ' | sed 's/\[vdr\]//'`
  echo "$param"
}

# start upgrade
${BIN_DIR}/vdrsternupgrade.sh || true

arg="vdr $(read_vdr_configuration) -P \"easyvdr -c /storage/.config/vdropt/conf.d/easyvdr.ini\""

# kill splash image (CoreELEC)
killall splash-image || true

# needed for locale / OSD language
. /storage/.profile
export LOCPATH=/storage/.kodi/addons/service.locale/locpath

# VFD: show clock
if [ -e /tmp/openvfd_service ]; then
  echo "" > /tmp/openvfd_service
fi

# really start VDR
if [ -z "$VDR_LD_PRELOAD" ]; then
   sh -c "LD_PRELOAD=$LD_PRELOAD_MALI LD_LIBRARY_PATH=$LIB_DIR:$LIB_DIR/vdr:$LD_LIBRARY_PATH ${BIN_DIR}/$arg"
else
   sh -c "LD_PRELOAD=\"$LD_PRELOAD_MALI:$VDR_LD_PRELOAD\" LD_LIBRARY_PATH=$LIB_DIR:$LIB_DIR/vdr:$LD_LIBRARY_PATH ${BIN_DIR}/$arg"
fi
