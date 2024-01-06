#!/bin/sh

# Start only if /storage/.config/remote.conf exists
if [ ! -f /storage/.config/remote.conf ]; then
    exit 0
fi

# check if udev in CE has created the symlink for amremote (meson-remote):
while [ ! -e /dev/input/meson-remote ]; do sleep 1; done

# read configuration in profile
. /storage/.profile

if [ "${MESON_REMOTE_REPEAT}" = ""  ]; then
    MESON_REMOTE_REPEAT=150
fi

/usr/local/bin/ps3remote.py -s /dev/input/meson-remote -r ${MESON_REMOTE_REPEAT}
