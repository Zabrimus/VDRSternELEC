# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-LiTE-examples"
PKG_VERSION="e2382051f2570edf22103dfcdbff83937759d4e5"
PKG_SHA256="1964d1ee2601d8123293a0f326488dda6fc111b0357964dd30cd2594616606eb"
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
