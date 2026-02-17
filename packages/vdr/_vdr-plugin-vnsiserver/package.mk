# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vnsiserver"
PKG_VERSION="a24ed7b4d6538b6cf728e1dca60ecbb96d7510fa"
PKG_SHA256="3d5e9cb2537673fb745d2fcb6f03d327f835d98fae34de67381060bfb8497f68"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-vnsiserver"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-vnsiserver/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-wirbelscan vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-vnsiserver-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper) $(get_pkg_directory _vdr-plugin-wirbelscan)"
PKG_DEPENDS_UNPACK="vdr-helper _vdr-plugin-wirbelscan"
PKG_LONGDESC="VDR plugin to handle Kodi clients."
PKG_BUILD_FLAGS="+speed"

pre_build_target() {
  WIRBELSCAN_DIR=$(get_build_dir _vdr-plugin-wirbelscan)
  ln -sf ${WIRBELSCAN_DIR}/wirbelscan_services.h ${PKG_BUILD}
}

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
