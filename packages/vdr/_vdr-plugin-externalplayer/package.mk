# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-externalplayer"
PKG_VERSION="0.3.5"
PKG_SHA256="8307db0106bdea39ae21157bc496a832fbf7998d94c592aacb8bb69143f81df9"
PKG_LICENSE="GPL"
PKG_SITE="https://www.uli-eckhardt.de/vdr/external.en.shtml"
PKG_URL="https://www.uli-eckhardt.de/vdr/download/vdr-externalplayer-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="externalplayer-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"

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
  zip -qrum9 "${INSTALL}/usr/local/config/externalplayer-sample-config.zip" storage
}
