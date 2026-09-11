# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_irmpconfig"
PKG_VERSION="4818efbbcd5d03638274d1959788a650947e33c4"
PKG_SHA256="91392e726fb600c6c72a479a3cb6ef1bf9a01b6156cbc611fc1692095da3ca91"
PKG_LICENSE="GPL 2"
PKG_SITE="https://github.com/j1rie/IRMP_PICO"
PKG_URL="https://github.com/j1rie/IRMP_PICO/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="IRMP_PICO-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"
PKG_TOOLCHAIN="make"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

make_target() {
	cd $(get_build_dir _irmpconfig)/irmpconfig/Linux
	${MAKE}
}

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/local/bin
    cp $(get_build_dir _irmpconfig)/irmpconfig/Linux/irmpconfig ${INSTALL}/usr/local/bin
}
