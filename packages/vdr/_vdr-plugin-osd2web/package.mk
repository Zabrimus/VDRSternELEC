# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-osd2web"
PKG_VERSION="ff86565c41789fad24daf4f86da297cbf0111048"
PKG_SHA256="dc69bef11f7a5ac23e89310bc2696fdb3c9dcfcc8914d1b4c35582d66676af76"
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
