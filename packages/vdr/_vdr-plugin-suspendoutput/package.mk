# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-suspendoutput"
PKG_VERSION="2.1.0"
PKG_SHA256="3109de8b18431613b8ebd5d9a2dd8b6b730a8efd321beb2b13508ae1825c80ed"
PKG_LICENSE="GPL"
PKG_SITE="http://phivdr.dyndns.org/vdr/vdr-suspendoutput"
PKG_URL="http://phivdr.dyndns.org/vdr/vdr-suspendoutput/vdr-suspendoutput-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="suspendoutput-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="Suspends VDR output"

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
  zip -qrum9 "${INSTALL}/usr/local/config/suspendoutput-sample-config.zip" storage
}
