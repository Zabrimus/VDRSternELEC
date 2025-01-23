# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-xmltv4vdr"
PKG_VERSION="d53f2346732da182ef001de6eab64cf89c0ee8cc"
PKG_SHA256="58f3152d8e2a5187c3b3d8146f9e2338cad4f483988fd7b0ae78fa0de1b9b7b3"
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
