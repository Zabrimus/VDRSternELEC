#!/bin/bash

set -e

sed -i "s/# CONFIG_DRM_QXL is not set/CONFIG_DRM_QXL=y/" projects/Generic/linux/linux.x86_64.conf
sed -i "s/virtio/virtio qxl/" projects/Generic/devices/x11/options

sed -i -E "s/^(LABEL=\"subsystem_pci\".*)$/\1\nDRIVER==\"qxl\", ENV{xorg_driver}=\"swrast\", TAG+=\"systemd\", ENV{SYSTEMD_WANTS}+=\"xorg-configure@qxl.service\"/" packages/x11/xserver/xorg-server/udev.d/97-xorg.rules



