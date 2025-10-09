# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_raft"
PKG_VERSION="dbdbfa3eef2250050310160134aabe69054deb42"
PKG_SHA256="0db29cd33c29687deec81235f3f0988ce21984f33e017f89301329da882a4ed0"
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