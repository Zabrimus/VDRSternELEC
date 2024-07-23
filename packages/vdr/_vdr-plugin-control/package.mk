# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-control"
PKG_VERSION="7d9f45e9a8e65e6987d3fdfeebd5eda8f9fcd0de"
PKG_SHA256="ea406abe05e2e3d704ea84f976eb4f930edc15e4eef121c9a624d8b1f1cdd94f"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control"
PKG_URL="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-control-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
