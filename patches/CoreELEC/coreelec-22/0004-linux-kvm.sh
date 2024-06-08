#!/bin/bash

set -e

sed -i -e "s/# CONFIG_VIRTUALIZATION is not set/CONFIG_VIRTUALIZATION=y/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
sed -i -e "s/# CONFIG_VHOST_MENU is not set/CONFIG_VHOST_MENU=y/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
sed -i -e "s/# CONFIG_EXPERT is not set/CONFIG_EXPERT=y/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
sed -i -e "s/# CONFIG_VSOCKETS is not set/CONFIG_VSOCKETS=y/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
sed -i -e "s/# CONFIG_SECURITY_APPARMOR is not set/CONFIG_SECURITY_APPARMOR=y/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf

echo "CONFIG_KVM=y"                               >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_VHOST_NET=m"                         >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_VHOST_VSOCK=m"                       >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y"         >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_ARCH_RANDOM=y"                       >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=y" >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_DEFAULT_SECURITY_APPARMOR=y"         >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
echo "CONFIG_AUDIT=y"                             >> ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf
