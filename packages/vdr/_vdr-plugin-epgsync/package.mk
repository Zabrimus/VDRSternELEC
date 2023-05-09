# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epgsync"
PKG_VERSION="1.0.1"
PKG_SHA256="b9e57e9c2dbebf20d5d193c84e991ae6e3a941db4b5b45780e239210f31a51e2"
PKG_LICENSE="GPL"
PKG_SITE="http://vdr.schmirler.de/"
PKG_URL="http://vdr.schmirler.de/epgsync/vdr-epgsync-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="epgsync-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-svdrpservice vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr _vdr-plugin-svdrpservice vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
