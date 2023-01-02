# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media"
PKG_VERSION="e45bb724b6a8ab9a4f55bd924522fca97c5f900c"
PKG_SHA256="ef3a236aae1d8e511a657fcd0f8cf5a016b8c93b152b6c559c50dc43c3410b8b"
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
