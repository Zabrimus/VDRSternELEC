#!/bin/bash

set -e

sed -i "s#-Dwith_x11=yes -Dwith_glx=no -Dwith_wayland=no#-Dwith_x11=yes -Dwith_glx=yes -Dwith_wayland=no#" packages/multimedia/libva/package.mk
sed -i "s#PKG_DEPENDS_TARGET=\"toolchain libX11 libXext libXfixes libdrm\"#PKG_DEPENDS_TARGET=\"toolchain libX11 libXext libXfixes libdrm libglvnd\"#" packages/multimedia/libva/package.mk




