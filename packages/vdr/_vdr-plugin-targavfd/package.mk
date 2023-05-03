# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-targavfd"
PKG_VERSION="36dda7933465fd556b3b0ec848923aebe15fbe87"
PKG_SHA256="552425ae30ff6483aa10300b3b92795a7ab883a9d679dc115918af0de323c1cc"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-targavfd"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-targavfd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-targavfd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libusb"
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
  zip -qrum9 "${INSTALL}/usr/local/config/targavfd-sample-config.zip" storage
}
