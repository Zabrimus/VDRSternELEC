# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_inputstream.adaptive"
PKG_VERSION="21.5.9-Omega"
PKG_SHA256="e391b3ea4dd353c44d1819ae8db6eb5da6cfa73408ff134703bd436c7b194df7"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/xbmc/inputstream.adaptive"
PKG_URL="https://github.com/xbmc/inputstream.adaptive/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi-platform bento4 expat"
PKG_SECTION=""
PKG_SHORTDESC="inputstream.adaptive"
PKG_LONGDESC="inputstream.adaptive"

PKG_CMAKE_OPTS_TARGET="-DENABLE_INTERNAL_BENTO4=true"

if [ "${TARGET_ARCH}" = "x86_64" ] || [ "${TARGET_ARCH}" = "arm" ]; then
  PKG_DEPENDS_TARGET+=" nss"
fi

pre_configure_target() {
	mkdir -p ${PKG_BUILD}/include
	cp -a ${PKG_DIR}/includes/* ${PKG_BUILD}/include
}
