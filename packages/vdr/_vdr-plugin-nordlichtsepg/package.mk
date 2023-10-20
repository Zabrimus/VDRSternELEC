# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-nordlichtsepg"
PKG_VERSION="746226785d61e3e69cbbcd1d3ee605fdf351c5ca"
PKG_SHA256="1a18d23734b49715a0c0523b4b077cf32b5e9a31bff0f2b54479a2119e587834"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lmaresch/vdr-plugin-nordlichtsepg"
PKG_URL="https://github.com/lmaresch/vdr-plugin-nordlichtsepg/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-nordlichtsepg-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libiconv vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib/iconv -liconv"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
