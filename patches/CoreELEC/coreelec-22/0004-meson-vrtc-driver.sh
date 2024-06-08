#!/bin/bash

set -e

sed -i -e "s/# CONFIG_RTC_DRV_PCF8563 is not set/CONFIG_RTC_DRV_PCF8563=m/" ./projects/Amlogic-ce/devices/Amlogic-no/linux/linux.aarch64.conf

echo "CONFIG_RTC_DRV_MESON_VRTC=m"  >> ./projects/Amlogic-ce/devices/Amlogic-ne/linux/linux.aarch64.conf
