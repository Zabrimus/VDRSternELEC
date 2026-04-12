# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-live"
PKG_VERSION="00cecfcd35a2171bb60c526ddcb077fa85715b2d"
PKG_SHA256="08a078f016e186fbf14686535cbcdd34935894549007c18edf648ff11a248065"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-live"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-live/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr tntnet pcre2 libiconv cxxtools vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_SOURCE_DIR="vdr-plugin-live-${PKG_VERSION}"
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
