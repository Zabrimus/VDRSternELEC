# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-wirbelscan"
PKG_VERSION="2023.02.19"
PKG_SHA256="239dbf4e4f93addaed2326895a547d2f6d4d0bcbe6fc0c5a05301789e6cbb9d2"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gen2vdr.de/wirbel/wirbelscan/index2.html"
PKG_URL="https://www.gen2vdr.de/wirbel/wirbelscan/vdr-wirbelscan-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain _vdr _librepfunc vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _librepfunc"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="Performs a channel scans for DVB-T, DVB-C and DVB-S"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
