# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vnsiserver"
PKG_VERSION="d3c028c43806a2037fea852249e7fc58f5c73712"
PKG_SHA256="616fc2b763359d0b4b3d756f9b33efbba4dc31ab4271954de3697bc35db91dd9"
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
PKG_BUILD_FLAGS="+speed"

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
