# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-wirbelscancontrol"
PKG_VERSION="0.0.3"
PKG_SHA256="93418d31bb757cccea9f81edd13a3e84ca0cf239c30252afbf0ced68e9ef6bd5"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gen2vdr.de/wirbel/wirbelscancontrol/index2.html"
PKG_URL="https://www.gen2vdr.de/wirbel/wirbelscancontrol/vdr-wirbelscancontrol-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain _vdr gettext:host _vdr-plugin-wirbelscan"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory _vdr-plugin-wirbelscan)"
PKG_LONGDESC="Adds menu entry for wirbelscan at VDR."

pre_build_target() {
  WIRBELSCAN_DIR=$(get_build_dir _vdr-plugin-wirbelscan)
  ln -sf ${WIRBELSCAN_DIR}/wirbelscan_services.h ${PKG_BUILD}
}

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/wirbelscancontrol-sample-config.zip" storage
}
