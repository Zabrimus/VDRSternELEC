# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media"
PKG_VERSION="68819728735f02e6904728ba2f895394ed76e8d9"
PKG_SHA256="f874e0c5c109e7a93ef4f1114e565519657f40186486032c874fd57baa22bcf8"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/DirectFB2-media/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 ffmpeg"
PKG_LONGDESC="DirectFB2-media contains additional font/image/video providers for DirectFB2."
PKG_SOURCE_DIR="DirectFB2-media-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
