# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vompserver"
PKG_VERSION="6544d026851dc6d6df7927a8bbb8529410b7896c"
PKG_SHA256="37f0369a6d6f784ee4bc98bfd45e4f990cfe057efefdfbcc93636d950114b9eb"
PKG_LICENSE="GPL"
PKG_SITE="https://www.loggytronic.com/vomp.php"
PKG_URL="https://git.vomp.tv/vompserver.git"
PKG_SOURCE_DIR="_vdr-plugin-vompserver-${PKG_VERSION}"
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
  zip -qrum9 "${INSTALL}/usr/local/config/vompserver-sample-config.zip" storage
}
