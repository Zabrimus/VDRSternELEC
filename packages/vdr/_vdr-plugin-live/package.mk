# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-live"
PKG_VERSION="449f0a83ca54af2177ed6c675b3042e4e3fb08d8"
PKG_SHA256="bc71df788e1a6d6e9b30792aafe4db70b8eb759ddfe4d12d07489ccfa59831cd"
PKG_LICENSE="GPL"
PKG_SITE="https://codeberg.org/MarkusE/vdr-plugin-live"
PKG_URL="https://codeberg.org/MarkusE/vdr-plugin-live/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr pcre2 libiconv vdr-helper tntnet cxxtools openssl"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_SOURCE_DIR="vdr-plugin-live"
PKG_LONGDESC="Allows a comfortable operation of VDR and some of its plugins trough a web interface."
PKG_BUILD_FLAGS="+pic -parallel +speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -lssl -lcrypto"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
  export PKG_CONFIG=${TOOLCHAIN}/bin/pkg-config
  export ECPPC=${TOOLCHAIN}/bin/ecppc
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} live
}
