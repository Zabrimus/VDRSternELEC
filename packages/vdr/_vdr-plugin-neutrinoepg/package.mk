# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-neutrinoepg"
PKG_VERSION="6455b0676ae5a88b0f8a4ae44bbbde22c583140b"
PKG_SHA256="6db55d3fe9ee9940481cd952ba7d00433d016dba26186636454ede2c94e47a3b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-neutrinoepg"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-neutrinoepg/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-neutrinoepg-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="Neutrinoepg is an EPG overview for vdr."
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
