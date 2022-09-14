#!/bin/bash

set -e

sed -i "s/--disable-x11-autolaunch/--enable-x11-autolaunch/" packages/sysutils/dbus/package.mk
sed -i "/--without-x/d" packages/sysutils/dbus/package.mk
