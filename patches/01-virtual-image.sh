#!/bin/bash

# Add vdr-all to image package.mk

set -e

sed -i 's/^true.*$/# VDR packages\n[ ! "${VDR}" = "no" ] \&\& PKG_DEPENDS_TARGET+=" vdr-all"\n\ntrue/' packages/virtual/image/package.mk
sed -i 's/^true.*$/# Preinstall Kodi Addons\nPKG_DEPENDS_TARGET+=" kodi-addons"\n\ntrue/' packages/virtual/image/package.mk
