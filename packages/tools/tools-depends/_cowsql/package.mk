# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_cowsql"
PKG_VERSION="1.15.4"
PKG_SHA256="91d023adf66d00eed0cd774db4e8a7d063d0d8c2d475e1edb8c7b42367f53f76"
PKG_LICENSE="LGPL 3"
PKG_SITE="https://github.com/cowsql/cowsql"
PKG_URL="https://github.com/cowsql/cowsql/archive/refs/tags/v${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _raft"
# PKG_SOURCE_DIR="incus-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
	PREFIX="/usr/local"
}