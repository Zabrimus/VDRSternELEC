# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-xmltv4vdr"
PKG_VERSION="0f121d57b40537aa0da621e3c21f4a9f09c9c4b2"
PKG_SHA256="d979a08f95a73237214b0056a2e57a8fe86db45c7f5a521c2bfccbe72d52deeb"
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
