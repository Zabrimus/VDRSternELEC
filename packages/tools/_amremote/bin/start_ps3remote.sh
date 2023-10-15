#!/bin/sh

# Start only if /storage/.config/remote.conf exists
if [ ! -f /storage/.config/remote.conf ]; then
    exit 0
fi

# check if udev in CE has created the symlink for amremote (meson-remote):
while [ ! -e /dev/input/meson-remote ]; do sleep 1; done

/usr/local/bin/ps3remote.py -s /dev/input/meson-remote -r 150
