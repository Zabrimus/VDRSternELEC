# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_vdr-plugin-webapp"
PKG_VERSION="7c16f749ed44ec5e8eb579d47844fbf16a4d009f"
PKG_SHA256="c74751aa879ff1d695e06461ffc108697f1f4a5730d876127d35e8d4e7a6cba4"
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
