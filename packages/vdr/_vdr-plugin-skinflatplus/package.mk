# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinflatplus"
PKG_VERSION="0d0559e0cc751665397019bc5e50dd2b90384d3f"
PKG_SHA256="be3ddd745151ea6735041d8a9f4e3f7af932b0bc42244982a0bd7782f4136980"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MegaV0lt/vdr-plugin-skinflatplus"
PKG_URL="https://github.com/MegaV0lt/vdr-plugin-skinflatplus/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-skinflatplus-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _graphicsmagick"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"
PKG_MAKE_OPTS_TARGET="IMAGELIB=graphicsmagick"
PKG_MAKEINSTALL_OPTS_TARGET="SKINFLATPLUS_WIDGETDIR=/storage/.config/vdropt-sample/plugins/skinflatplus"

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
  zip -yqrum9 "${INSTALL}/usr/local/config/skinflatplus-sample-config.zip" storage
}
