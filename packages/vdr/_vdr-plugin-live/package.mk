# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-live"
PKG_VERSION="635cb0dfba47ff5b2d8ef2a3b5d940d51fe21893"
PKG_SHA256="7c97f196d4819f71f7c1ee2211c5029ecfd9e2b0e006d7f05796e2f65f3129d6"
PKG_LICENSE="GPL"
PKG_SITE="https://codeberg.org/MarkusE/vdr-plugin-live"
PKG_URL="https://codeberg.org/MarkusE/vdr-plugin-live/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr tntnet pcre2 libiconv cxxtools vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_SOURCE_DIR="vdr-plugin-live"
PKG_LONGDESC="Allows a comfortable operation of VDR and some of its plugins trough a web interface."
PKG_BUILD_FLAGS="+pic -parallel +speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
  export PKG_CONFIG=${TOOLCHAIN}/bin/pkg-config
  export ECPPC=${TOOLCHAIN}/bin/ecppc
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} live
}
