# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_irmpconfig"
PKG_VERSION="3714ff6593a6b403a1422c0ae54e4d4acc6309cb"
PKG_SHA256="8c36426defaace02a1ec1d786647fb2349b5cc068c1eb52746deb3f23c81819d"
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
