# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-osdteletext"
PKG_VERSION="0454171c8c046f61fc8c86e15e7fdf19011cd642"
PKG_SHA256="8425c6ed237907edfcce13c81365541938f3dbc7594819c598c383375ecf63b9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-osdteletext"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-osdteletext/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-osdteletext-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr cairo vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="Osd-Teletext displays the teletext directly on the OSD."
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
