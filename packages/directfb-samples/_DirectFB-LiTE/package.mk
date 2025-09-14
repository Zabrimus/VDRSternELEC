# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB-LiTE"
PKG_VERSION="164bb5eca507c3cee1be2adf3798745f305495d7"
PKG_SHA256="a5ccee787cde8e1c422e946830bbf9e7c11670c2cf87d396175459c15dc7dc67"
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
