# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-channellists"
PKG_VERSION="4ecadb61fc469d662d1273ce26b1ab20ec291e31"
PKG_SHA256="b8041a5c38c1e857292c3ca007c41b3a309599936c52f4faba22c13e5ce44324"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-channellists"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-channellists/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-channellists-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
