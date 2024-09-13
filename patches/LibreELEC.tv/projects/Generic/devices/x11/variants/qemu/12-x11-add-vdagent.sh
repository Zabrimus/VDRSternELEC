#!/bin/bash

set -e

cat >> packages/x11/xserver/xorg-server/package.mk<< EOF

PKG_DEPENDS_TARGET+=" _spice_vdagent"
EOF


