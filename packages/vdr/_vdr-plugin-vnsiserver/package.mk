# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vnsiserver"
PKG_VERSION="57e4c71faae7414e15d3e36c4cfb4e7d7f518f72"
PKG_SHA256="7b457810665acba164b53473f70f980957a77e0563eab090321b2aa05aac9706"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-vnsiserver"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-vnsiserver/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
if [ "${DISTRO}" = "CoreELEC" ]; then
  WIRBELSCAN="_vdr-plugin-wirbelscan-ce"
else
  WIRBELSCAN="_vdr-plugin-wirbelscan"
fi
PKG_DEPENDS_TARGET="toolchain _vdr ${WIRBELSCAN} vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-vnsiserver-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr ${WIRBELSCAN} vdr-helper)"
PKG_LONGDESC="VDR plugin to handle Kodi clients."

pre_build_target() {
  WIRBELSCAN_DIR=$(get_build_dir ${WIRBELSCAN})
  ln -sf ${WIRBELSCAN_DIR}/wirbelscan_services.h ${PKG_BUILD}
}

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
