# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media"
PKG_VERSION="f71d1857a3dd83c8ce32c6dfd21b00ccc4f470d6"
PKG_SHA256="a795a54510759cc1abb489c0035bfea65c20515516f3a06ef1bcf3ad3a1a809c"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2-media"
PKG_URL="https://github.com/directfb2/DirectFB2-media/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 ffmpeg"
PKG_LONGDESC="DirectFB2-media contains additional font/image/video providers for DirectFB2."
PKG_SOURCE_DIR="DirectFB2-media-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
