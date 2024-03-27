# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-control"
PKG_VERSION="d43e31910720f3342c6ad01d4dda9146c3a69d5c"
PKG_SHA256="3a91fd0b0953a4f6de458d6148f1138f5c7560062ebcd40e73c786355ebac51a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control"
PKG_URL="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-control-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
