# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

. $(get_pkg_directory libXfixes)/package.mk

PKG_NAME="cef-libXfixes"
PKG_LONGDESC="libXfixes for cef"
PKG_URL=""
PKG_DEPENDS_UNPACK+=" libXfixes"
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
