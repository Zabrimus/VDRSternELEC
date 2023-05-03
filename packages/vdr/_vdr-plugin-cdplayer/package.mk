# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-cdplayer"
PKG_VERSION="1.2.5"
PKG_SHA256="f4e565d57551790790d491bf573068cfd6ac7bdd1fa527abbb59e84d2744269f"
PKG_LICENSE="GPL"
PKG_SITE="https://uli-eckhardt.de/vdr/cdplayer.en.shtml"
PKG_URL="https://uli-eckhardt.de/vdr/download/vdr-cdplayer-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="cdplayer-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libcddb _libcdio_paranoia"
PKG_DEPENDS_CONFIG="_vdr _libcddb _libcdio_paranoia"
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
  zip -qrum9 "${INSTALL}/usr/local/config/cdplayer-sample-config.zip" storage
}
