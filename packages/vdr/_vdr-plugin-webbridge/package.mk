# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-webbridge"
PKG_VERSION="49c54e9654c0269e6a82bc524908d55ca4bcc9b0"
PKG_SHA256="f94a25377af98b99af19840dfc07026c8c2872e3550c8bd40e634af5953cc7ad"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-webbridge"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-webbridge/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_SOURCE_DIR="vdr-plugin-webbridge-${PKG_VERSION}"
PKG_LONGDESC="Bridge between websockets and VDR SVDRP"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
