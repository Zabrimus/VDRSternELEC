# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media"
PKG_VERSION="7286f0f91a531ee12452c3bd3e0f49a0343b31bc"
PKG_SHA256="549774faaac8e3bed37a6066264b450802f4201a0d3d5a4fb8e5d34e0d87e4aa"
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
