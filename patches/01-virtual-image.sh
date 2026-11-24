#!/bin/bash

# Add vdr-all to image package.mk

set -e

sed -i 's/^true.*$/# VDR packages\n[ ! "${VDR}" = "no" ] \&\& PKG_DEPENDS_TARGET+=" vdr-all"\n\ntrue/' packages/virtual/image/package.mk
sed -i 's/^true.*$/# Tools\nPKG_DEPENDS_TARGET+=" tools"\n\ntrue/' packages/virtual/image/package.mk

# sed changes nothing, if the line doesn't exist anymore
if ! grep -q '" vdr-all"' packages/virtual/image/package.mk || ! grep -q '" tools"' packages/virtual/image/package.mk; then
  echo "ERROR: $0: vdr-all/tools not added to packages/virtual/image/package.mk"
  exit 1
fi
