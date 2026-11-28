#!/bin/bash

set -e

sed -i "s#-Dadditional-fonts-dirs=no#-Dadditional-fonts-dirs=/usr/local/vdrshare/fonts,/storage/.config/vdropt/fonts#" packages/x11/other/fontconfig/package.mk

if ! grep -q -- "-Dadditional-fonts-dirs=/usr/local/vdrshare/fonts" packages/x11/other/fontconfig/package.mk; then
  echo "ERROR: $0: VDR fonts not added to packages/x11/other/fontconfig/package.mk"
  exit 1
fi
