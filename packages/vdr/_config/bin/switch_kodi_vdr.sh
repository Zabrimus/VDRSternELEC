#!/bin/sh

#
# This script will be started by systemd (switch_kodi_vdr.path via switch_kodi_vdr.service) after the file /storage/.cache/switch_kodi_vdr has been changed
#

# Read .profile
. /storage/.profile

# Start either Kodi or VDR on request
. /storage/.cache/switch_kodi_vdr


if [ "${START_PRG}" = "vdr" ]; then
   #check if Kodi is already running (should never be the case after reboot)
   if pgrep "kodi.bin" > /dev/null ; then
      systemctl stop kodi
      /storage/.config/vdropt/ClearOSD.sh || true
   fi
   if [ ! -z ${SWITCH_VDR_SCRIPT} ] && pgrep "vdr" > /dev/null ; then
      eval ${SWITCH_VDR_SCRIPT} attach
   else
      systemctl start vdropt
   fi
elif [ "${START_PRG}" = "kodi" ]; then
   #check if vdr is running
   if pgrep "vdr" > /dev/null ; then
      if [ ! -z ${SWITCH_VDR_SCRIPT} ]; then
         eval ${SWITCH_VDR_SCRIPT} detach
         /storage/.config/vdropt/ClearOSD.sh || true
      else
         systemctl stop vdropt
      fi
   fi
   systemctl unmask kodi
   systemctl start kodi
fi
