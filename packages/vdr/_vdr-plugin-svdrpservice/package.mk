# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-svdrpservice"
PKG_VERSION="7f10bcd5db1f6f4ac8b71bedbff3ddef4f77ec14"
PKG_SHA256="c95a1c8ecf706be02d66445275489f457fd29682011199b74e5ad60556956329"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-svdrpservice"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-svdrpservice/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-svdrpservice-${PKG_VERSION}"
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
