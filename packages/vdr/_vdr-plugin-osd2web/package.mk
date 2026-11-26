# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-osd2web"
PKG_VERSION="4a03831bea690ef57166f5238f4c8738e0beb68b"
PKG_SHA256="9b6e9bed2c4995fbaaca900cbd56c1ebfbd0a219002804ea9fcc8971ad3c9b8f"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/vdr-plugin-osd2web"
PKG_URL="https://github.com/horchi/vdr-plugin-osd2web/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-osd2web-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libwebsockets libexif vdr-helper"
PKG_DEPENDS_CONFIG="_vdr libwebsockets libexif"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} osd2web
}
