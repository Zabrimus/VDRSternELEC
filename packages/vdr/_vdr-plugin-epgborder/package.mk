# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epgborder"
PKG_VERSION="0ad5fd97de4e8329faffc0641a1766d5a7a38470"
PKG_SHA256="b321e7919f647ad44aa6aa28d245d68fcec4b41bc6a029ec23e12a68fdf26637"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/M-Reimer/vdr-plugin-epgborder"
PKG_URL="https://github.com/M-Reimer/vdr-plugin-epgborder/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-epgborder-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR Plugin which blocks EPG storage starting from a set border channel number "
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
