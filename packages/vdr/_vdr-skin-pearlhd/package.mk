# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-skin-pearlhd"
PKG_VERSION="ec0cce3d035649acf2aa0d4dec4d660aac708081"
PKG_SHA256="6f44a9d93230b5e5739ce83502d55f3fb95e8d613ee931861a506d17bf9c3434"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/unf/vdr-skin-pearlhd"
PKG_URL="https://github.com/unf/vdr-skin-pearlhd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-skin-pearlhd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-text2skin _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="PearlHD is a skin for text2skin, designed in 2009/2010 by mapovi (don_jan) on vdr-portal.de."
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
