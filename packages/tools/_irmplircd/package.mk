# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_irmplircd"
PKG_VERSION="fe096b3f35ca753b88decc83b648ee85392f84fc"
PKG_SHA256="5e640dd529d7ae9d1ed514b3ca145827b78b166c16672f265b6ef1a54d5722b5"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/realglotzi/irmplircd"
PKG_URL="https://github.com/realglotzi/irmplircd/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="irmplircd-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="LIRC compatible daemon for IRMPUSB IR receiver "
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
	PREFIX="/usr/local"

	# copy _system.d folder
    mkdir -p ${INSTALL}/${PREFIX}/config/irmplircd/system.d
    for i in $(ls ${PKG_DIR}/_system.d/*); do
    	cp ${PKG_DIR}/_system.d/* ${INSTALL}/${PREFIX}/config/irmplircd/system.d
	done

	# copy _udev.rules.d folder
    mkdir -p ${INSTALL}/${PREFIX}/config/irmplircd/udev.rules.d
    for i in $(ls ${PKG_DIR}/_udev.d/*); do
    	cp ${PKG_DIR}/_udev.d/* ${INSTALL}/${PREFIX}/config/irmplircd/udev.rules.d
	done
}