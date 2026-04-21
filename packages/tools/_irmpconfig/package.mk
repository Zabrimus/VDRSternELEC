# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_irmpconfig"
PKG_VERSION="2557a1e7f15d98cba1088a1d44e3a78811023a36"
PKG_SHA256="75f17543e26e19676235c03e64a8638c5f9581ebc43bae74adb96b5ff563aa4c"
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
