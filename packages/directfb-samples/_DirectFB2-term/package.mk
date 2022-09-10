# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-term"
PKG_VERSION="68f1498e32d98b175b28725564122d3fd9f4dbee"
PKG_SHA256="1c4f5ed1a899a32a5ee1a6ae82a8694a6686a73c89947907c04995e6b776c9cb"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/DFBTerm/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 _DirectFB-LiTE"
PKG_LONGDESC="DFBTerm is a terminal emulator runnning on DirectFB and based on libzvt."
PKG_SOURCE_DIR="DFBTerm-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
