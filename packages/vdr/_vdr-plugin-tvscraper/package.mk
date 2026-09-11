# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvscraper"
PKG_VERSION="26e8c6866891b1ff7bd7b86d962ed2cf7d57eb0d"
PKG_SHA256="ab28b7fe679d34a44ac85a4b838b887885278158fb943297c59441afa420af71"
PKG_LICENSE="GPL"
PKG_SITE="https://codeberg.org/MarkusE/vdr-plugin-tvscraper"
PKG_URL="https://codeberg.org/MarkusE/vdr-plugin-tvscraper/archive/${PKG_VERSION}.tar.gz"
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
