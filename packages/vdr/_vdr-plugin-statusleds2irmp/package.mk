# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-statusleds2irmp"
PKG_VERSION="d431bd1a582d77af1585fc9068df1725a6d41e61"
PKG_SHA256="988cc5865152394360ea3a5a068b5a4b12239d43a285f7b1bb436a6801fff6ea"
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
  PLUGIN="$(cat ${PKG_BUILD}/vdr-plugin-statusleds2irmp/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}

make_target() {
	cd $(get_build_dir _vdr-plugin-statusleds2irmp)/vdr-plugin-statusleds2irmp
	${MAKE}
}
