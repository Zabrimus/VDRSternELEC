# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-streamdev"
PKG_VERSION="da74779591827ad7e10493b0eade65a11c525171"
PKG_SHA256="1479c64016714dfe360934359c6d22c133f30d56cd6b8792e0c861bfd5aaec23"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-streamdev"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-streamdev/archive/${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr openssl"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="This PlugIn is a VDR implementation of Video Transfer and a basic HTTP Streaming Protocol."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  APIVERSION=$(pkg-config --variable=apiversion vdr)

  cp ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client2.so.${APIVERSION}
  cp ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client3.so.${APIVERSION}
  cp ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client4.so.${APIVERSION}

  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

  # copy configuration files
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/streamdev-server
  cp $(get_build_dir _vdr-plugin-streamdev)/streamdev-server/* ${INSTALL}/storage/.config/vdropt-sample/plugins/streamdev-server

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/streamdev-sample-config.zip" storage
}