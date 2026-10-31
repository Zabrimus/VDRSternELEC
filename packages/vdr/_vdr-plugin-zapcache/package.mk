# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-zapcache"
PKG_VERSION="2af2eb20f6367fe4f2eea4808039c8a2586e825a"
PKG_SHA256="6e5d118f364c39689a561226ba7e7ec82ed00ea18a39d182790dfed7bb535165"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/rellla/vdr-plugin-zapcache"
PKG_URL="https://github.com/rellla/vdr-plugin-zapcache/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-zapcache-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="zapcache - tunes the neighbour channels ahead and buffers them for a faster channel switch"
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
