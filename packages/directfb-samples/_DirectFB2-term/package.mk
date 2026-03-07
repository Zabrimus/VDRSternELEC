# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-term"
PKG_VERSION="e9e54964516e0556c07dc2b0a2df1382532e002c"
PKG_SHA256="0cf9342b9a327ac493a47433d244587485891d01d17bf2f7efc9a236ba2c10be"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DFBTerm"
PKG_URL="https://github.com/directfb2/DFBTerm/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 _DirectFB-LiTE"
PKG_LONGDESC="DFBTerm is a terminal emulator runnning on DirectFB and based on libzvt."
PKG_SOURCE_DIR="DFBTerm-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
