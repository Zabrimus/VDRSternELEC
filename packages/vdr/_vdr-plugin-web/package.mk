# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_vdr-plugin-web"
PKG_VERSION="eb2bc33822aa2e8e2ee38a2239f5399f60e6ecca"
PKG_SHA256="2d4215ea00e85c9c282822d0a3f0fc420c3ed765d028fa56935141ebd1142290"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-web"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-web/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper ffmpeg"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-web-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="HbbTV Plugin. Needs cefbrowser and remotetranscoder"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
