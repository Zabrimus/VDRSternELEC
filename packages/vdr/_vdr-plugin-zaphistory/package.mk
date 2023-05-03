# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-zaphistory"
PKG_VERSION="bf75bc764bb6510386db646295f62d74df4cc911"
PKG_SHA256="79749c3e9b5a8ef00b7613b01a9173ec25254d9c9a14bab303624394f6b1a66c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-zaphistory"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-zaphistory/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-zaphistory-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="The plugins provides a history of the latest viewed channels."

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
  zip -qrum9 "${INSTALL}/usr/local/config/zaphistory-sample-config.zip" storage
}
