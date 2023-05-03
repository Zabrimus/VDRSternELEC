# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-cecremote"
PKG_VERSION="1.5.0"
PKG_SHA256="406f3cda3f26483d49be015f9ff5ae2430898f7db38bc1aec90eff06fe3c5cd1"
PKG_LICENSE="GPL"
PKG_SITE="https://www.uli-eckhardt.de/vdr/cec.de.shtml"
PKG_URL="https://www.uli-eckhardt.de/vdr/download/vdr-cecremote-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="cecremote-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libcec pugixml"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  BUILD_DIR=$(get_build_dir _vdr-plugin-cecremote)
  PLGRES_DIR="${INSTALL}/storage/.config/vdropt-sample/plugins/cecremote"
  mkdir -p ${PLGRES_DIR}
  cp ${BUILD_DIR}/contrib/* ${PLGRES_DIR}

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
  zip -qrum9 "${INSTALL}/usr/local/config/cecremote-sample-config.zip" storage
}
