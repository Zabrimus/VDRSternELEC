# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

. $(get_pkg_directory at-spi2-core)/package.mk

PKG_NAME="cef-at-spi2-core"
PKG_LONGDESC="Protocol definitions and daemon for D-Bus at-spi, built with libXtst."
PKG_URL=""
PKG_DEPENDS_UNPACK+=" at-spi2-core"
PKG_DEPENDS_TARGET+=" libXtst"
PKG_BUILD_FLAGS="-sysroot +speed"

unpack() {
  mkdir -p ${PKG_BUILD}
  tar --strip-components=1 -xf ${SOURCES}/${PKG_NAME:4}/${PKG_NAME:4}-${PKG_VERSION}.tar.xz -C ${PKG_BUILD}
}
