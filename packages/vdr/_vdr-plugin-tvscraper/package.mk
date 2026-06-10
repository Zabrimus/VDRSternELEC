# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvscraper"
PKG_VERSION="402f25a3afdbbe7a04293d531d1b5cc03c6714c7"
PKG_SHA256="021863b3c1681791f3b5ffa5542fb2b88e80fccccfa6ebf1b0039d5bda9c568a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-tvscraper"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-tvscraper/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-tvscraper-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr curl vdr-helper sqlite _gumbo"
PKG_DEPENDS_CONFIG="_vdr _gumbo sqlite curl"
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
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} tvscraper
}
