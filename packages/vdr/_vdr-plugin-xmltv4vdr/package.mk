# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-xmltv4vdr"
PKG_VERSION="2b21fa7c666d0d9c8d4ab3f3054b2c8442e0a7cc"
PKG_SHA256="20ce03525c65bb17f28dc79fb5c90a1499f8be3443d074a0f6038c2be9c439e5"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/FireFlyVDR/vdr-plugin-xmltv4vdr"
PKG_URL="https://github.com/FireFlyVDR/vdr-plugin-xmltv4vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="main"
PKG_SOURCE_DIR="vdr-plugin-xmltv4vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libxml2 sqlite vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="VDR plugin to import EPG data from external sources in XMLTV format"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
