#!/bin/sh

#
# This script will be started after the file /storage/.cache/.watch_prg has been changed
#

# Read .profile
. /storage/.profile

# Start either Kodi or VDR on request
. /storage/.cache/switch_kodi_vdr

if [ "${START_PRG}" = "vdr" ]; then
  systemctl stop kodi
  if [ ! -z ${SWITCH_VDR_SCRIPT} ]; then
    eval ${SWITCH_VDR_SCRIPT} attach
  else
    systemctl start vdropt
  fi
elif [ "${START_PRG}" = "kodi" ]; then
  if [ ! -z ${SWITCH_VDR_SCRIPT} ]; then
    eval ${SWITCH_VDR_SCRIPT} detach
  else
    systemctl stop vdropt
  fi
  systemctl start kodi
fi
