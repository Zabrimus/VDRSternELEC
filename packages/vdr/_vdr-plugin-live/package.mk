# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-live"
PKG_VERSION="96c0000ce4de0b95802db0cfb8cd706d2fb17c43"
PKG_SHA256="effc39f13583e17af77a270d2ee422abe9a6807eaa203c16c355f4594a81595a"
PKG_LICENSE="GPL"
PKG_SITE="https://codeberg.org/MarkusE/vdr-plugin-live"
PKG_URL="https://codeberg.org/MarkusE/vdr-plugin-live/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr pcre2 libiconv vdr-helper tntnet cxxtools openssl gettext"
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
  export TOOLCHAIN=${TOOLCHAIN}

  ##### dirty hack ################################
  # Build at first po2js with host compiler
  cd $(get_build_dir _vdr-plugin-live)
  ${HOSTCC} -o build/po2js build/po2js.cpp -I$(get_build_dir _vdr-plugin-live) -I${TOOLCHAIN}/include -lstdc++ -L${TOOLCHAIN}/lib -lgettextpo
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} live
}
