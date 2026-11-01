# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-zapcache"
PKG_VERSION="176555bf937bad9d9df14f1f2ff4eda4922475e0"
PKG_SHA256="a589dbe1de74402011e00384875432f3f3be70fe43f15e0fe245db5f989492bd"
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
