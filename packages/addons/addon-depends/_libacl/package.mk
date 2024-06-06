# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libacl"
PKG_VERSION="2.3.2"
PKG_SHA256="5f2bdbad629707aa7d85c623f994aa8a1d2dec55a73de5205bac0bf6058a2f7c"
PKG_LICENSE="GPL 2"
PKG_SITE="https://savannah.nongnu.org/projects/acl/"
PKG_URL="http://download.savannah.nongnu.org/releases/acl/acl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_SOURCE_DIR="acl-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Commands for Manipulating POSIX Access Control Lists"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           "
