# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media"
PKG_VERSION="e40fdf8d33395d699cdf06ef303b6bbedefcd987"
PKG_SHA256="f874e0c5c109e7a93ef4f1114e565519657f40186486032c874fd57baa22bcf8"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/DirectFB-media-samples/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 _DirectFB2-media"
PKG_LONGDESC="DirectFB-media-samples contains simple applications that can be used to test DirectFB media providers."
PKG_SOURCE_DIR="DirectFB2-media-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
