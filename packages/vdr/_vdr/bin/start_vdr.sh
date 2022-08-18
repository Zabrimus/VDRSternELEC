#!/bin/sh

CONF_DIR="/storage/.config/vdropt"
BIN_DIR="XXBINDIRXX"
LIB_DIR="XXLIBDIRXX"

read_plugin_configuration () {
  param=`cat ${CONF_DIR}/conf.d/$1.conf  | sed "s/#.*$//g ; s/^#$//g ; s/ *$//g" | tr '\n' ' ' | sed  "s/\[/-P \\'/ ; s/\]// ; s/ *$/\'/"`
  echo "$param"
}

read_vdr_configuration () {
  param=`cat ${CONF_DIR}/conf.d/vdr.conf | sed "s/#.*$//g ; s/^#$//g ; s/ *$//g" | tr '\n' ' ' | sed 's/\[vdr\]//'`
  echo "$param"
}

arg="vdr $(read_vdr_configuration)"

# read VDR plugin start parameters
file=$(cat ${CONF_DIR}/enabled_plugins)

for line in $file; do
  pluginarg="$(read_plugin_configuration $line)"
  arg="$arg $pluginarg"
done

# kill splash image (CoreELEC)
killall splash-image

# needed for locale / OSD language
. /storage/.profile
export LOCPATH=/storage/.kodi/addons/service.locale/locpath

# really start VDR
if [ -z "$VDR_LD_PRELOAD" ]; then
   sh -c "LD_PRELOAD=/usr/lib/libMali.so LD_LIBRARY_PATH=$LIB_DIR:$LIB_DIR/vdr:$LD_LIBRARY_PATH ${BIN_DIR}/$arg"
else
   sh -c "LD_PRELOAD=\"/usr/lib/libMali.so:$VDR_LD_PRELOAD\" LD_LIBRARY_PATH=$LIB_DIR:$LIB_DIR/vdr:$LD_LIBRARY_PATH ${BIN_DIR}/$arg"
fi
