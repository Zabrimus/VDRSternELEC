# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-systeminfo"
PKG_VERSION="33edb3d8e2f1c7dfc8fed912f56f57d15b50dc53"
PKG_SHA256="0dac45dc662c61c843a650a0dcba18bb0c2b945285a0c6030aea1a3eae5b5d52"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FireFlyVDR/vdr-plugin-systeminfo"
PKG_URL="https://github.com/FireFlyVDR/vdr-plugin-systeminfo/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-systeminfo-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/systeminfo
  cp $(get_build_dir _vdr-plugin-systeminfo)/scripts/* ${INSTALL}/storage/.config/vdropt-sample/plugins/systeminfo

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
