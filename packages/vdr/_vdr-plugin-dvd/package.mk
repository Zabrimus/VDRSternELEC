# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dvd"
PKG_VERSION="66d30ed0411c2ce42bc965476a4024f86810defa"
PKG_SHA256="c15b7aa9289a0773ba3bcffe75611e9e104c97357331fed74dae826176e32eef"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-dvd"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-dvd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-dvd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libdvdnav _libdvdread _a52dec vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
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
