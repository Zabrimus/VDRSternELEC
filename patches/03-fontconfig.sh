#!/bin/bash

set -e

sed -i "s#--without-add-fonts#--with-add-fonts=/usr/local/vdrshare/fonts,/storage/.config/vdropt/fonts#" packages/x11/other/fontconfig/package.mk

if ! grep -q -- "--with-add-fonts=/usr/local/vdrshare/fonts" packages/x11/other/fontconfig/package.mk; then
  echo "ERROR: $0: VDR fonts not added to packages/x11/other/fontconfig/package.mk"
  exit 1
fi
