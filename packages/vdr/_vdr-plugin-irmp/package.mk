# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-irmp"
PKG_VERSION="543b628274253a91b7faee4ac13cb731052c8870"
PKG_SHA256="49769daba87787d80d709a051ee4ad8a921a66baf9b5222de883d14a0e647e82"
PKG_LICENSE="GPL 2"
PKG_SITE="https://github.com/j1rie/IRMP_PICO"
PKG_URL="https://github.com/j1rie/IRMP_PICO/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="IRMP_PICO-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"
PKG_TOOLCHAIN="make"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/vdr-plugin-irmp/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}

   rm -rf ${INSTALL}/usr/lib/udev/rules.d
      mkdir -p ${INSTALL}/usr/lib/udev/rules.d
      cp -PR ${PKG_DIR}/_udev.d/*.rules ${INSTALL}/usr/lib/udev/rules.d
}

make_target() {
	cd $(get_build_dir _vdr-plugin-irmp)/vdr-plugin-irmp
	${MAKE}
}
