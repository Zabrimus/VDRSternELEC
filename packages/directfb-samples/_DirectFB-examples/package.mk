# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-examples"
PKG_VERSION="a4be967abe06d1aee6f469cef584133d3ce889ff"
PKG_SHA256="1a2d94a86b74371477b74f26c60398927e53cdbf26b0a8ead852fb45ee5591b4"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/DirectFB-examples/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2"
PKG_LONGDESC="DirectFB-examples contains simple applications that can be used to demonstrate and test various DirectFB features."
PKG_SOURCE_DIR="DirectFB-examples-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
