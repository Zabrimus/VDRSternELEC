#!/bin/sh

# /usr/local/bin/VDRCoreELEC.sh
#
# This script will be started once after boot
#

# if libcec exists, set a symbolic link
if [ -f /usr/lib/libcec.so.6.0.2 ] && [ ! -f /var/lib/libcec.so.6 ]; then
   (cd /var/lib && ln -s /usr/lib/libcec.so.6.0.2 libcec.so.6)
fi

if [ -f /usr/lib/libcec.so.7.0.0 ] && [ ! -f /var/lib/libcec.so.7 ]; then
   (cd /var/lib && ln -s /usr/lib/libcec.so.7.0.0 libcec.so.7)
fi

# Start either Kodi or VDR after boot
. /storage/.profile

# delete existing file which will be watched to switch between Kodi and VDR
# (the new one will be created by echo command)
rm -f /storage/.cache/switch_kodi_vdr

# monitor file changes
systemctl start switch_kodi_vdr.path


# check if we got started by timer
if [ -f /storage/.config/vdropt/wakeupacpi ]; then
   /storage/.config/vdropt/wakeupacpi start
fi

if [ "${START_PRG}" = "vdr" ]; then
   systemctl mask kodi
   /usr/lib/coreelec/smp-affinity.sh || true
   echo "START_PRG=vdr" > /storage/.cache/switch_kodi_vdr
elif [ "${START_PRG}" = "kodi" ]; then
   echo "START_PRG=kodi" > /storage/.cache/switch_kodi_vdr
fi