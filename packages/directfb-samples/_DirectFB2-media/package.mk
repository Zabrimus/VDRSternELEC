# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media"
PKG_VERSION="6ed3fe63185bd9c933ab0d4ef1df4456e7b58b7f"
PKG_SHA256="c977c6cc2d7bd60f174c9108415fcfa917ad031f44d05d3230f3b7281b62e8cf"
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
