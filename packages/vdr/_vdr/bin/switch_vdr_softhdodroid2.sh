#!/bin/bash

# Use this script to either attach or detach the VDR frontend
# The script takes one parameter 'attach' or 'detach' which can be used to distinguish between the desired command.

# The following sample works only for softhdodroid
# For all other VDR frontend plugins, the script needs to be adapted

if [ "$1" = "attach" ]; then
  echo 4 > /sys/module/amvdec_h264/parameters/dec_control
  systemctl start vdropt
elif [ "$1" = "detach" ]; then
  systemctl stop vdropt
  echo rm pip0 > /sys/class/vfm/map
fi
