# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-remote"
PKG_VERSION="0.7.0-6"
PKG_SHA256="e7ae97f8ff853a98f90514b20f5d0a06cbef0790c45e9c304ba07cabe09f5ae4"
PKG_LICENSE="GPL"
PKG_SITE="http://www.escape-edv.de/endriss/vdr/"
PKG_URL="https://salsa.debian.org/vdr-team/vdr-plugin-remote/-/archive/debian/${PKG_VERSION}/vdr-plugin-remote-debian-${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-remote-debian-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="remote - Remote Control plugin for the Video Disk Recorder (VDR)"

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
  zip -qrum9 "${INSTALL}/usr/local/config/control-sample-config.zip" storage
}
