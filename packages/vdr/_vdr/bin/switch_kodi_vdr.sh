#!/bin/sh

# 
# This script will be started after the file /storage/.cache/.watch_prg has been changed
#

# Read ,profile
. /storage/.profile

# Start either Kodi or VDR on request
. /storage/.cache/switch_kodi_vdr
