# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-cdplayer"
PKG_VERSION="1.2.5"
PKG_SHA256="f4e565d57551790790d491bf573068cfd6ac7bdd1fa527abbb59e84d2744269f"
PKG_LICENSE="GPL"
PKG_SITE="https://uli-eckhardt.de/vdr/cdplayer.en.shtml"
PKG_URL="https://uli-eckhardt.de/vdr/download/vdr-cdplayer-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="cdplayer-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libcddb _libcdio_paranoia vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _libcddb _libcdio_paranoia"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
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
