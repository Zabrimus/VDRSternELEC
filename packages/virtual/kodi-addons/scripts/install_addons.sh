#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

# extract all addons
for i in $(ls /usr/share/kodi/storage_addons/*.zip); do
  ADDON=$(basename $i | sed -e "s/-[^-]*.zip$//")

  # if [ ! -d /storage/.kodi/addons/$ADDON ]; then
    unzip -o -qq -d /storage/.kodi/addons $i
  # fi
done;
