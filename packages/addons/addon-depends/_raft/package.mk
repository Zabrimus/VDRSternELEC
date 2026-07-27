# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_raft"
PKG_VERSION="148951f79a1ed529d6f112661a3067494f1a0917"
PKG_SHA256="1a03b49b0dd213956ec9fd857a4a026df6c083abdc6f8e27b337bb3ef1d37aed"
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