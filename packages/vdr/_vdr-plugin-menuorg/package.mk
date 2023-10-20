# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-menuorg"
PKG_VERSION="203218929551ec4c6f1dd45c6d8012c214eaa2c8"
PKG_SHA256="88a9b2cd73db39ecffdeaf405eca746ada09432637b73ad8a35fb24dac609930"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-menuorg"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-menuorg/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-menuorg-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libxmlplusplus vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _libxmlplusplus"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="This plug-in allows to reorganize VDR's main OSD menu."
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  BUILD_DIR=$(get_build_dir _vdr-plugin-menuorg)
  PLGRES_DIR="${INSTALL}/storage/.config/vdropt-sample/plugins"
  mkdir -p ${PLGRES_DIR}
  cp ${BUILD_DIR}/menuorg.xml ${PLGRES_DIR}

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
