# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_directfb2"
PKG_VERSION="ad438fce3601e86658e72e4f795bec187014ef4f"
PKG_SHA256="3b7f3df4a9efc9d91f535634082a3ddcb1e3abf23b9ecd3e909cb0ed6bd54cd3"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/DirectFB2/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _fluxcomp:host"
PKG_LONGDESC="DirectFB (Direct Frame Buffer) is a set of graphics APIs implemented on top of the Linux Frame Buffer (fbdev) abstraction layer."
PKG_BUILD_FLAGS="+pic"
PKG_SOURCE_DIR="DirectFB2-${PKG_VERSION}"
PKG_TOOLCHAIN="meson"

#PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
