#!/bin/bash

set -e

sed -i "s/# CONFIG_DRM_QXL is not set/CONFIG_DRM_QXL=y/" projects/Generic/linux/linux.x86_64.conf
sed -i "s/virtio/virtio qxl/" projects/Generic/devices/x11/options
