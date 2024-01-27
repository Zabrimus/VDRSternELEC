# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_irmplircd"
PKG_VERSION="70fef522424c1f1b0aaeb34699196479c27c9ce0"
PKG_SHA256="a1418321fc057c6105e11021c931f39534ede97497aaaf6a007af8fd4b2153de"
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