# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-favorites"
PKG_VERSION="a1b640ef65e4e0c9305cc2b0acc458cfdfe1d045"
PKG_SHA256="9f99097059646f27248e8d6d45643c89142a4d254d00155fc8615852643ecd6b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-favorites"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-favorites/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-favorites-${PKG_VERSION}"
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
