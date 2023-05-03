# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dummydevice"
PKG_VERSION="2.0.0"
PKG_SHA256="5c0049824415bd463d3abc728a3136ee064b60a37b5d3a1986cf282b0d757085"
PKG_LICENSE="GPL"
PKG_SITE="http://www.vdr-wiki.de/wiki/index.php/Dummydevice-plugin"
PKG_URL="http://phivdr.dyndns.org/vdr/vdr-dummydevice/vdr-dummydevice-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="This plugin can be used to run vdr as recording server without any output devices."

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
  zip -qrum9 "${INSTALL}/usr/local/config/dummydevice-sample-config.zip" storage
}
