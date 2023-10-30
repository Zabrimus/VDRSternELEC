#!/bin/sh

#
# This script will be started once after boot just before Kodi starts
#
# Default: Start Kodi
#

# create file which will be watched to switch between Kodi and VDR
rm -f /storage/.cache/switch_kodi_vdr
touch /storage/.cache/switch_kodi_vdr

# if libcec exists, set a symbolic link
if [ -f /usr/lib/libcec.so.6.0.2 ] && [ ! -f /var/lib/libcec.so.6 ]; then
   (cd /var/lib && ln -s /usr/lib/libcec.so.6.0.2 libcec.so.6)
fi

# monitor file changes
systemctl start switch_kodi_vdr.path

# Start either Kodi or VDR on reboot
. /storage/.profile
