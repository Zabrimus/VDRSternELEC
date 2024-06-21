#!/bin/sh

set -e

if [ -f /sys/class/bl301_manager/setup_bl301 ]; then
    echo 1 > /sys/class/bl301_manager/setup_bl301
fi

if [ -f /sys/class/bl30_manager/setup_bl30 ]; then
    echo 1 > /sys/class/bl30_manager/setup_bl30
fi

