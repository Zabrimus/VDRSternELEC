# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-statusleds"
PKG_VERSION="dc3c0256957d97290e346df276f00345226498e0"
PKG_SHA256="fbc6b4867fdaaa3c5ea8f035505d3d6a040bdfc26d3966ce8cddd4136ba30743"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/j1rie/vdr-plugin-statusleds"
PKG_URL="https://github.com/j1rie/vdr-plugin-statusleds/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-statusleds-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="This plugin shows the status of VDR via LED."
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
