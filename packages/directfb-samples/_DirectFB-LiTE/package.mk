# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-LiTE"
PKG_VERSION="1446944955b45b54c26405455b0949b34439d942"
PKG_SHA256="669bbae9018d726c80850620aa36bda9f60aa7bc2391220f8c8d04f0ebca12a3"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/LiTE"
PKG_URL="https://github.com/directfb2/LiTE/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2"
PKG_LONGDESC="LiTE stands for Lightweight Toolkit Enabler and is a simple user interface library on top of DirectFB."
PKG_SOURCE_DIR="LiTE-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
