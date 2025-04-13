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
for i in 6 7 8 9; do
  if [ -L /usr/lib/libcec.so.${i} ] && [ -e /usr/lib/libcec.so.${i} ]; then
      (cd /var/lib && ln -s /usr/lib/libcec.so.${i} libcec.so.${i})
  fi
done

# monitor file changes
systemctl start switch_kodi_vdr.path

# check if we got started by timer
/storage/.config/vdropt/wakeupacpi start

# Start either Kodi or VDR on reboot
. /storage/.profile
