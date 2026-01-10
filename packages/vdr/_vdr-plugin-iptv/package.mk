# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-iptv"
PKG_VERSION="659b4fd494fbd5b9dba0446f8258fa1621c22c04"
PKG_SHA256="fae5b60758f00c8c85ba639eaab520f32ef9fea428c13df4308d6589f3333a0b"
PKG_LICENSE="GPL"
PKG_ORIGINAL_SITE="http://www.saunalahti.fi/~rahrenbe/vdr/iptv/"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-iptv/"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-iptv/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr curl vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_SOURCE_DIR="vdr-plugin-iptv-${PKG_VERSION}"
PKG_LONGDESC="vdr-iptv is an IPTV plugin for the Video Disk Recorder (VDR)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

pre_makeinstall_target() {
	mkdir -p $(get_build_dir _vdr-plugin-iptv)/iptv
	cp $(get_pkg_directory _vdr-plugin-iptv)/iptv/* $(get_build_dir _vdr-plugin-iptv)/iptv
}

post_makeinstall_target() {
  mkdir -p $(get_install_dir _vdr-plugin-iptv)/storage/.config/vdropt/plugins/iptv/vlcinput
  mkdir -p $(get_install_dir _vdr-plugin-iptv)/storage/.config/vdropt/plugins/iptv/m3u-conf

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
