# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dvd"
PKG_VERSION="f9d47bd806854cb56a9c6324e7deb33c6ace3628"
PKG_SHA256="73d1d06469729225871899b060a9a6a15eb2018fdf8276aa4f9ba80d31eb885a"
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
