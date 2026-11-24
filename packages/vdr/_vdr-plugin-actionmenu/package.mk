# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-actionmenu"
PKG_VERSION="d642c039c79cd4e83b6b2bbb7c80cbc37c4b3026"
PKG_SHA256="59e445e13c7d51485e216224d7a50fec739cfdfff766decf82a86ff638df0165"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/rellla/vdr-plugin-actionmenu"
PKG_URL="https://github.com/rellla/vdr-plugin-actionmenu/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-actionmenu-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR plugin: a menu with configurable actions (SVDRP commands, keys, shell commands, channels) for the keys of the remote control"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
