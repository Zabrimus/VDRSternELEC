#!/bin/sh

# 
# This script will be started after the file /storage/.cache/.watch_prg has been changed
#

# Start either Kodi or VDR on request
. /storage/.cache/switch_kodi_vdr

if [ "${START_PRG}" = "vdr" ]; then
   systemctl stop kodi
   echo 4 > /sys/module/amvdec_h264/parameters/dec_control
   systemctl start vdropt
elif [ "${START_PRG}" = "kodi" ]; then
   systemctl stop vdropt
   echo rm pip0 > /sys/class/vfm/map
   systemctl start kodi
fi
