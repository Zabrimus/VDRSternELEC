# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-examples"
PKG_VERSION="eecf1019b29933a45578e62aea5f08a884d30fbc"
PKG_SHA256="4bcdd40641c714b7169894678807f177e191a14cbc7e17df213411de111d1afc"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB-examples"
PKG_URL="https://github.com/directfb2/DirectFB-examples/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2"
PKG_LONGDESC="DirectFB-examples contains simple applications that can be used to demonstrate and test various DirectFB features."
PKG_SOURCE_DIR="DirectFB-examples-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
