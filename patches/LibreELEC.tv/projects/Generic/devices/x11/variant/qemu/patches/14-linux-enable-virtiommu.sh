#!/bin/bash

set -e

sed -i "s/# CONFIG_VIRTIO_IOMMU is not set/CONFIG_VIRTIO_IOMMU=y/" projects/Generic/linux/linux.x86_64.conf
