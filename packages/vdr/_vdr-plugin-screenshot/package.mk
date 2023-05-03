# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-screenshot"
PKG_VERSION="ccb535801df1ae2d272c3ebed1927a8edb85915b"
PKG_SHA256="8f994a5c606ff10f0e34e98aca18a91290a4ecf98ba6db8f6b24b0ad84ffc265"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jowi24/vdr-screenshot"
PKG_URL="https://github.com/jowi24/vdr-screenshot/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-screenshot-${PKG_VERSION}"
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
  zip -qrum9 "${INSTALL}/usr/local/config/screenshot-sample-config.zip" storage
}
