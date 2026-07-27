# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-LiTE-examples"
PKG_VERSION="5745b77775a10b59b259e7f5dc848a693650b018"
PKG_SHA256="3cca31ca3a750205ed9e7d8c9d7f7dbc163c54bdb25bc1166ff619ac11aabf9d"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/LiTE-examples"
PKG_URL="https://github.com/directfb2/LiTE-examples/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 _DirectFB-LiTE"
PKG_LONGDESC="LiTE-examples contains simple applications that can be used to demonstrate and test various LiTE features."
PKG_SOURCE_DIR="LiTE-examples-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
