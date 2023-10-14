#!/bin/sh

# Start only if /storage/.config/remote.conf exists
if [ ! -f /storage/.config/remote.conf ]; then
    exit 0
fi

REMOTECMD="/usr/local/bin/ps3remote.py -s /dev/input/meson-remote -r 150 &"

# check if udev in CE has created the symlink for amremote (meson-remote):
while [ ! -e /dev/input/meson-remote ]; do sleep 1; done

# python-Script zum Anlegen eines virtuellen input-devices starten
if [ $(/usr/bin/pgrep -f "ps3remote.py") ]; then
    echo "ps3remote.py is already running"
else
    echo "start ps3remote.py script"
    eval "$REMOTECMD"
fi

# wait for virtual input device, created by udev in CE:
while [ ! -e /dev/input/ps3remote ]; do sleep 1; done