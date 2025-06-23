# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dynamite"
PKG_VERSION="bb1c4665662615f1ca9be1061930db3f55531203"
PKG_SHA256="f6c0666aa06cb80efe809698c76263b20989048a58ad9feef4efcc83c714f9cd"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-dynamite"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-dynamite/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-dynamite-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr systemd vdr-helper"
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
