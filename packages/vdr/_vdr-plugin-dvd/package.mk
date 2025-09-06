# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dvd"
PKG_VERSION="a83a0ccc4b05711f544420b9b62fc5664e216d44"
PKG_SHA256="53d067c93a23c7205afafdd75dd606648e7f97b67c26737888a211cbb92628e0"
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
