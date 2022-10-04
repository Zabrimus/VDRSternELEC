#!/bin/bash

set -e

sed -i "s/# CONFIG_VIRTIO_IOMMU is not set/CONFIG_VIRTIO_IOMMU=y/" projects/Generic/linux/linux.x86_64.conf
sed -i "s/# CONFIG_BT_VIRTIO is not set/CONFIG_BT_VIRTIO=y/" projects/Generic/linux/linux.x86_64.conf
sed -i "s/# CONFIG_SND_VIRTIO is not set/CONFIG_SND_VIRTIO=y/" projects/Generic/linux/linux.x86_64.conf
sed -i "s/# CONFIG_VFIO is not set/CONFIG_VFIO=y/" projects/Generic/linux/linux.x86_64.conf

echo "CONFIG_VFIO_PCI=y" >> projects/Generic/linux/linux.x86_64.conf
echo "CONFIG_VFIO_PLATFORM=y" >> projects/Generic/linux/linux.x86_64.conf
