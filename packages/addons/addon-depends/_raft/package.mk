# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_raft"
PKG_VERSION="cce5fac8c16da531fff5b41a83212edc600b71aa"
PKG_SHA256="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
PKG_LICENSE="LGPL 3"
PKG_SITE="https://github.com/cowsql/raft"
PKG_URL="https://github.com/cowsql/raft/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="raft-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared --disable-static \
                           --with-sysroot=${SYSROOT_PREFIX}"

pre_configure_target() {
  autoreconf -i
}