# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-extrecmenung"
PKG_VERSION="c4305b4cae62574df7d92273ee6ea5d7d3ca9a06"
PKG_SHA256="32463a9217b3d0d932a023e7830958275508241d478c6ce8295be912527755fa"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/extrecmenung"
PKG_URL="https://gitlab.com/kamel5/extrecmenung/-/archive/${PKG_VERSION}/extrecmenung-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="extrecmenung-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  CUSTOM_CFLAGS="-Woverloaded-virtual -fPIC" VDRDIR="${VDR_DIR}" make SHELL="sh -x"
}

makeinstall_target() {
  VDR_DIR=$(get_build_dir _vdr)
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" VDRDIR="${VDR_DIR}" install
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
  zip -qrum9 "${INSTALL}/usr/local/config/extrecmenung-sample-config.zip" storage
}
