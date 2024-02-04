# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_incus"
PKG_VERSION="0.5"
PKG_SHA256="43c29ad1bac5c906db0e283c0b879402e24603fc81d1aef4a0e38e660f51a80a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lxc/incus"
PKG_URL="https://github.com/lxc/incus/releases/download/v${PKG_VERSION}.0/incus-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain go:host _cowsql"
PKG_SOURCE_DIR="incus-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

#pre_configure_target() {
#  	export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
#	export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
#}

pre_make_target() {
  	export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
	export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

  	go_configure
}

makeinstall_target() {
   echo "TODO"
}

#post_makeinstall_target() {
#	PREFIX="/usr/local"
#}