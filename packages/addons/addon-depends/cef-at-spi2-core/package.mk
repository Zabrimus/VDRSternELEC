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

  SRC_PART="${SOURCES}/${PKG_NAME:4}/${PKG_NAME:4}-${PKG_VERSION}.tar"

  if [ -f "${SRC_PART}.xz" ]; then
	tar --strip-components=1 -xf ${SRC_PART}.xz -C ${PKG_BUILD}
  elif [ -f "${SRC_PART}.gz" ]; then
	tar --strip-components=1 -xf ${SRC_PART}.gz -C ${PKG_BUILD}
  else
	tar --strip-components=1 -xf ${SRC_PART}.bz2 -C ${PKG_BUILD}
  fi

}
