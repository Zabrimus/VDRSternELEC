# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_attr"
PKG_VERSION="2.5.2"
PKG_SHA256="39bf67452fa41d0948c2197601053f48b3d78a029389734332a6309a680c6c87"
PKG_LICENSE="GPL 2"
PKG_SITE="https://savannah.nongnu.org/projects/attr"
PKG_URL="http://download.savannah.nongnu.org/releases/attr/attr-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="attr-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Commands for Manipulating Filesystem Extended Attributes"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||")"
}

post_makeinstall_target() {
	PREFIX="/usr/local"
}