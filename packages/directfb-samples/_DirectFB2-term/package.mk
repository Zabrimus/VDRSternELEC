# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-term"
PKG_VERSION="9b6948cb8da326ba9404faae2545e7054c75bd5e"
PKG_SHA256="4bfe6df6027de0a6d722334c5efe773affbe56b014f7831d696a5fc276745eff"
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
