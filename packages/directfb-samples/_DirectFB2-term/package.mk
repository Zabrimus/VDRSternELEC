# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-term"
PKG_VERSION="c6e3d58e7b3a1a789bde9afd172d143a5610a313"
PKG_SHA256="d5d2ca1c06d215f86064bdc597e1531f557f779989611a1913df837b669b86c9"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DFBTerm"
PKG_URL="https://github.com/directfb2/DFBTerm/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 _DirectFB-LiTE"
PKG_LONGDESC="DFBTerm is a terminal emulator runnning on DirectFB and based on libzvt."
PKG_SOURCE_DIR="DFBTerm-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
