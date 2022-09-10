# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-LiTE"
PKG_VERSION="1f9a04862db154d409110aa9ce8ec8567b6018bb"
PKG_SHA256="ab53f840c4de727f77fe7c8a7ec5584d7727ea2baa435f6f40d8bc229e9ba1f6"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/LiTE/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2"
PKG_LONGDESC="LiTE stands for Lightweight Toolkit Enabler and is a simple user interface library on top of DirectFB."
PKG_SOURCE_DIR="LiTE-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
