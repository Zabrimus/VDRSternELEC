# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvguideng"
PKG_VERSION="51da4fcf963e363bc5198b6cefda5b9ac87b593b"
PKG_SHA256="1d1bc55ccb675c51bcefa3785fd21e2022022ce583f983c693f3e7c3fd4f771c"
PKG_LICENSE="GPL2"
PKG_SITE="https://gitlab.com/kamel5/tvguideng.git"
PKG_URL="https://gitlab.com/kamel5/tvguideng/-/archive/${PKG_VERSION}/tvguideng-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="tvguideng-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-skindesigner"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  SKINDESIGNER_DIR=$(get_install_dir _vdr-plugin-skindesigner)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${SKINDESIGNER_DIR}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make
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
  zip -qrum9 "${INSTALL}/usr/local/config/tvguideng-sample-config.zip" storage
}
