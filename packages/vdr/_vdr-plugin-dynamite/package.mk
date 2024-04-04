# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dynamite"
PKG_VERSION="488b5f234465d19f81d7f50c0113bbadb71b34d1"
PKG_SHA256="d5dbf0050e068a698db9bdb0aa7286c50fa603b85eab69f02ddd8f6bee97f0f2"
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
