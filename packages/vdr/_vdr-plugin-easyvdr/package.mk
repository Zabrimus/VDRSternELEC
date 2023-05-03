# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-easyvdr"
PKG_VERSION="2021.01.24.1"
PKG_SHA256="384e0f7ff47ef4158e70b6cb71a7639679c1f6256c234dec4006e4c9a880650a"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gen2vdr.de/wirbel/easyvdr/index2.html"
PKG_URL="https://www.gen2vdr.de/wirbel/easyvdr/vdr-easyvdr-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="easyvdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr Python3"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory Python3) $(get_pkg_directory _mariadb-connector-c)"
PKG_LONGDESC="This plugin is used to retrieve EPG data into the VDR. The EPG data was loaded from a mariadb database."

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
  zip -qrum9 "${INSTALL}/usr/local/config/easyvdr-sample-config.zip" storage
}
