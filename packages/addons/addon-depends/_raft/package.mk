# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_raft"
PKG_VERSION="47f18054186c596e133b4dfa84d1320978bdb86f"
PKG_SHA256="66b695cdb176af7149d16f5187e4c0afde2078b494e6ccfe5adb353cfa885913"
PKG_LICENSE="LGPL 3"
PKG_SITE="https://github.com/cowsql/raft"
PKG_URL="https://github.com/cowsql/raft/archive/${PKG_VERSION}.zip"
PKG_BRANCH="main"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="raft-${PKG_VERSION}"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared --disable-static \
                           --with-sysroot=${SYSROOT_PREFIX}"

pre_configure_target() {
  autoreconf -i
}