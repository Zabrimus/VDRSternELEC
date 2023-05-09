# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-seduatmo"
PKG_VERSION="d95a81551386f6bc824252d3294fc082b2469303"
PKG_SHA256="b220fa82751c6afac1df8be58125d1dc3804514e7b169bb566d2692f2f695c8d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-seduatmo"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-seduatmo/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-seduatmo-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} seduatmo
}
