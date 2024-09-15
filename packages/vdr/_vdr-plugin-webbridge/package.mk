# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-webbridge"
PKG_VERSION="2045855fa587a4b67fa609dc09a49d01de45633e"
PKG_SHA256="dbb6cf917593d1ca7c8b2986e3e01685059282ccfe93dc004045af42fd7562d4"
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
