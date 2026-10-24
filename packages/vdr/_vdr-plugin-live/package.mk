# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-live"
PKG_VERSION="bca111df7966a8bd50b57acc810c697856190897"
PKG_SHA256="08644113df96039d4b8cbd6e45a5562eb6f418e9ee9d63d425031dd7982efad2"
PKG_LICENSE="GPL"
PKG_SITE="https://codeberg.org/MarkusE/vdr-plugin-live"
PKG_URL="https://codeberg.org/MarkusE/vdr-plugin-live/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr pcre2 libiconv vdr-helper tntnet cxxtools openssl gettext"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_SOURCE_DIR="vdr-plugin-live"
PKG_LONGDESC="Allows a comfortable operation of VDR and some of its plugins trough a web interface."
PKG_BUILD_FLAGS="+pic +speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -lssl -lcrypto"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
  export PKG_CONFIG=${TOOLCHAIN}/bin/pkg-config
  export ECPPC=${TOOLCHAIN}/bin/ecppc
  export TOOLCHAIN=${TOOLCHAIN}

  ##### dirty hack ################################
  # Build at first po2js with host compiler
  cd $(get_build_dir _vdr-plugin-live)
  ${HOSTCC} -o build/po2js build/po2js.cpp -I$(get_build_dir _vdr-plugin-live) -I${TOOLCHAIN}/include -lstdc++ -L${TOOLCHAIN}/lib -lgettextpo
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} live
}
