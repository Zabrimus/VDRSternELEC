# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-radio"
PKG_VERSION="cd405d05d42b8a604982c5b85895ba8018f6c228"
PKG_SHA256="06c5d5f5b55f157d5d83fde19a8f41293caab63c6735aea21a58b604b41edd18"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-radio"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-radio/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-radio-${PKG_VERSION}"
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
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/radio
  cp -r $(get_build_dir _vdr-plugin-radio)/config/scripts ${INSTALL}/storage/.config/vdropt-sample/plugins/radio
  cp -r $(get_build_dir _vdr-plugin-radio)/config/mpegstill ${INSTALL}/storage/.config/vdropt-sample/plugins/radio

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
