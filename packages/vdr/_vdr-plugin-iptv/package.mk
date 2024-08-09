# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-iptv"
PKG_VERSION="63b38ca788e2e03ce894d89119dd2b745ccd315c"
PKG_SHA256="caf17018dffba3ad1abfefab824878ce41e5090fa2b87462e26a42c44502ce7a"
PKG_LICENSE="GPL"
PKG_ORIGINAL_SITE="http://www.saunalahti.fi/~rahrenbe/vdr/iptv/"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-iptv/"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-iptv/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr curl vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_SOURCE_DIR="vdr-plugin-iptv-${PKG_VERSION}"
PKG_LONGDESC="vdr-iptv is an IPTV plugin for the Video Disk Recorder (VDR)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
