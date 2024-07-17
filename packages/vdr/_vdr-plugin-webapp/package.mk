# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_vdr-plugin-webapp"
PKG_VERSION="c190673501603d880e61689d60a80ac2c336944b"
PKG_SHA256="30837b9af22afecd68ab0c0818619ceefadbd9097b5812ce79c23326d8034107"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-webapp"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-webapp/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-webapp-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_DEPENDS_CONFIG="_vdr"
PKG_LONGDESC="Plugin which uses vdr-plugin-web for streaming"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt/plugins/webapp
  cp -a $(get_build_dir _vdr-plugin-webapp)/config/*.json ${INSTALL}/storage/.config/vdropt/plugins/webapp
  cp -a $(get_build_dir _vdr-plugin-webapp)/config/README ${INSTALL}/storage/.config/vdropt/plugins/webapp
  cp -a ${PKG_DIR}/config/webapp-apps.cfg ${INSTALL}/storage/.config/vdropt/plugins/webapp

  mkdir -p ${INSTALL}/usr/local/bin
  cp $(get_build_dir _vdr-plugin-webapp)/convm3u ${INSTALL}/usr/local/bin

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
