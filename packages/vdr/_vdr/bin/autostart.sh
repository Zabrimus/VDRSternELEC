#!/bin/sh

#
# This script will be started once after boot just before Kodi starts
#
# Default: Start Kodi
#

/usr/lib/coreelec/smp-affinity.sh || true

# create file which will be watched to switch between Kodi and VDR
rm -f /storage/.cache/switch_kodi_vdr
touch /storage/.cache/switch_kodi_vdr

# if libcec exists, set a symbolic link
if [ -f /usr/lib/libcec.so.6.0.2 ] && [ ! -f /var/lib/libcec.so.6 ]; then
   (cd /var/lib && ln -s /usr/lib/libcec.so.6.0.2 libcec.so.6)
fi

if [ -f /usr/lib/libcec.so.7.0.0 ] && [ ! -f /var/lib/libcec.so.7 ]; then
   (cd /var/lib && ln -s /usr/lib/libcec.so.7.0.0 libcec.so.7)
fi

# monitor file changes
systemctl start switch_kodi_vdr.path

# check if we got started by timer
/storage/.config/vdropt/wakeupacpi start

# Start either Kodi or VDR on reboot
. /storage/.profile
