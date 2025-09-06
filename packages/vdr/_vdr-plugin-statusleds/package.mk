# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-statusleds"
PKG_VERSION="cba41b0bb19fd85ad1e00db883a8df84a79b866e"
PKG_SHA256="6fc624930f134166c52722ed30c7d5cf97a3d096661049a888f11e9ce0d1f41a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/j1rie/vdr-plugin-statusleds"
PKG_URL="https://github.com/j1rie/vdr-plugin-statusleds/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-statusleds-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="This plugin shows the status of VDR via LED."
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
