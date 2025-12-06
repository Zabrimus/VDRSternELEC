# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_raft"
PKG_VERSION="2d8dfe8d91dc800bf5c5f85c8146f51947d3ca96"
PKG_SHA256="9224917fcd1d5236f7df96d8d1d5dbe8eba2098775f2412dec753c3b1e9b1daa"
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