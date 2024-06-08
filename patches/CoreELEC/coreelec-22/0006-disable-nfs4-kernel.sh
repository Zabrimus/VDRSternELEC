#!/bin/bash

set -e

sed -i -e "s/CONFIG_NFS_V4=y/# CONFIG_NFS_V4 is not set/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
sed -i -e "s/CONFIG_NFSD_V4=y/# CONFIG_NFSD_V4 is not set/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
