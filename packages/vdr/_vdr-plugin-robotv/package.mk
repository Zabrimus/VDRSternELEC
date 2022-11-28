# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_vdr-plugin-robotv"
PKG_VERSION="e9246b24cbdc855ff1bd87995f09b41cc77f41dc"
PKG_SHA256="aac31332b31c0d35405f575ad9f805161acbc1c0115afa33ddaf67248523d25c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/pipelka/vdr-plugin-robotv"
PKG_URL="https://github.com/pipelka/vdr-plugin-robotv/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr avahi"
PKG_SOURCE_DIR="vdr-plugin-robotv-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="RoboTV is a Android TV based frontend for VDR."
PKG_TOOLCHAIN="manual"

post_unpack() {
  mv ${PKG_BUILD}/CMakeLists.txt ${PKG_BUILD}/Original-CMakeLists.txt
}

pre_configure_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include
  export VDRDIR=${VDR_DIR}
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}"
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" install
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
  zip -qrum9 "${INSTALL}/usr/local/config/robotv-sample-config.zip" storage
}
