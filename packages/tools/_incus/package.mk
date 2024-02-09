# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_incus"
PKG_VERSION="0.5.1"
PKG_SHA256="99621ccf3f9edc10203ec29290f6686fcfd5e71be8fa9155dec051d3ff00d9f1"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lxc/incus"
PKG_URL="https://github.com/lxc/incus/releases/download/v${PKG_VERSION}/incus-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain go:host _cowsql _libacl"
PKG_SOURCE_DIR="incus-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  	export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||")"
}

make_target() {
	go_configure
	GO=${GOLANG} make  #SHELL='sh -x'
}