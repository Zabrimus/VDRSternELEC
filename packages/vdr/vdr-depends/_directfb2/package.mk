# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_directfb2"
# PKG_VERSION="cd4172c5c38ccfd11caaa53cbc33acb7724b55b4"
# PKG_SHA256="e8aa137247f307a587db893c298cfb43b3ff98a1d12d1bd55464f05bd0d3aa4e"
PKG_VERSION="ad438fce3601e86658e72e4f795bec187014ef4f"
PKG_SHA256="3b7f3df4a9efc9d91f535634082a3ddcb1e3abf23b9ecd3e909cb0ed6bd54cd3"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB2"
PKG_URL="https://github.com/directfb2/DirectFB2/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _fluxcomp:host"
PKG_LONGDESC="DirectFB (Direct Frame Buffer) is a set of graphics APIs implemented on top of the Linux Frame Buffer (fbdev) abstraction layer."
PKG_BUILD_FLAGS="+pic"
PKG_SOURCE_DIR="DirectFB2-${PKG_VERSION}"
PKG_TOOLCHAIN="meson"

# disabled until a build of linux-fusion is successful
# PKG_MESON_OPTS_TARGET="-Dmulti=true"
PKG_MESON_OPTS_TARGET="-Dmulti-kernel=false  \
					   -Dmulti=false \
					   "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/etc/
  cp ${PKG_DIR}/etc/* ${INSTALL}/etc/
}