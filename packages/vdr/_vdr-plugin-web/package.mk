# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_vdr-plugin-web"
PKG_VERSION="63e24e1c36b8831829edb0e1cb171a0dcb0952a3"
PKG_SHA256="443a53316f203221c9a04eae93f246f58ce31b5e3c243aa7d14afc43f1802bff"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-web"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-web/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper _graphicsmagick"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-web-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_LONGDESC="HbbTV Plugin. Needs cefbrowser and remotetranscoder"
PKG_MAKE_OPTS_TARGET="ENABLE_FAST_SCALE=1"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
