# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-systeminfo"
PKG_VERSION="a59901da27ed0e0d9a8d1566760b9e490eca9e06"
PKG_SHA256="031dd244fb3d2bcfbe42cfedfa07ba3840cb53ca9ae64878365194be8be2a1a0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FireFlyVDR/vdr-plugin-systeminfo"
PKG_URL="https://github.com/FireFlyVDR/vdr-plugin-systeminfo/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-systeminfo-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/systeminfo
  cp $(get_build_dir _vdr-plugin-systeminfo)/scripts/* ${INSTALL}/storage/.config/vdropt-sample/plugins/systeminfo

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
