# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dynamite"
PKG_VERSION="5a94153a27836752f878d3e83fe1a6720ebd76db"
PKG_SHA256="4cf9d1987bbd6223aece85dba12aa7fefae7779b8665cf40b8ad0bbe9166540e"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-dynamite"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-dynamite/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-dynamite-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr systemd"
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
  zip -qrum9 "${INSTALL}/usr/local/config/dynamite-sample-config.zip" storage
}
