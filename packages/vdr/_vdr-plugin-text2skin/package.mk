# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-text2skin"
PKG_VERSION="92118a6d62948ca9de535e344e7bd162b77e01e2"
PKG_SHA256="1270a64e2ffbe6d9cbd36a77e4c28c7ea104fc7fc4e34a6dc22c4f518b194204"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/unf/vdr-plugin-text2skin"
PKG_URL="https://github.com/unf/vdr-plugin-text2skin/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-text2skin-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR text2skin plugin – maintained fork with true colour OSD and VDR 2.8 support."
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
