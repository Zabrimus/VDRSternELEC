# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-neutrinoepg"
PKG_VERSION="4d784a5cbe469e8f307eb0109fbf58241405e149"
PKG_SHA256="85a8321d04e008d1563154d8bdf9663a1f7f207e5abecdd45c1e13fb01f06cb0"
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
