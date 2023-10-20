# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-externalplayer"
PKG_VERSION="0.3.5"
PKG_SHA256="8307db0106bdea39ae21157bc496a832fbf7998d94c592aacb8bb69143f81df9"
PKG_LICENSE="GPL"
PKG_SITE="https://www.uli-eckhardt.de/vdr/external.en.shtml"
PKG_URL="https://www.uli-eckhardt.de/vdr/download/vdr-externalplayer-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="externalplayer-${PKG_VERSION}"
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
