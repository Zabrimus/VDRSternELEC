# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-wirbelscancontrol"
PKG_VERSION="0.0.3"
PKG_SHA256="93418d31bb757cccea9f81edd13a3e84ca0cf239c30252afbf0ced68e9ef6bd5"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gen2vdr.de/wirbel/wirbelscancontrol/index2.html"
PKG_URL="https://www.gen2vdr.de/wirbel/wirbelscancontrol/vdr-wirbelscancontrol-${PKG_VERSION}.tgz"
if [ "${DISTRO}" = "CoreELEC" ]; then
  WIRBELSCAN="_vdr-plugin-wirbelscan-ce"
else
  WIRBELSCAN="_vdr-plugin-wirbelscan-ce"
fi
PKG_DEPENDS_TARGET="toolchain _vdr gettext:host ${WIRBELSCAN} vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr ${WIRBELSCAN} vdr-helper)"
PKG_LONGDESC="Adds menu entry for wirbelscan at VDR."

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
