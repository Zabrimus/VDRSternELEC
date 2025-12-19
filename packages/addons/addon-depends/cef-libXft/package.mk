# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

. $(get_pkg_directory libXft)/package.mk

PKG_NAME="cef-libXft"
PKG_LONGDESC="libXft for cef"
PKG_URL=""
PKG_DEPENDS_UNPACK+=" libXft"
PKG_BUILD_FLAGS="-sysroot"

# build tool switched from configure to meson
if [ "${PKG_MESON_OPTS_TARGET}" != "" ]; then
	PKG_MESON_OPTS_TARGET="-Ddefault_library=shared"
else
	PKG_CONFIGURE_OPTS_TARGET="--enable-shared --disable-static"
fi

unpack() {
  mkdir -p ${PKG_BUILD}
  tar --strip-components=1 -xf ${SOURCES}/${PKG_NAME:4}/${PKG_NAME:4}-${PKG_VERSION}.tar.xz -C ${PKG_BUILD}
}

