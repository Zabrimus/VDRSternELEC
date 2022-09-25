# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-xineliboutput"
PKG_VERSION="2.2.0+git20211212-2"
PKG_SHA256="c4e8d440f9ae37986021e192fdcbb27681ca06d5033b73b9bca6f824b96a6e0c"
PKG_LICENSE="GPL"
PKG_SITE="https://sourceforge.net/projects/xineliboutput"
PKG_URL="https://salsa.debian.org/vdr-team/vdr-plugin-xineliboutput/-/archive/debian/${PKG_VERSION}/vdr-plugin-xineliboutput-debian-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="vdr-plugin-xineliboutput-debian-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr glibc _xine-lib libX11 mesa _xcb-util-wm _libxcb _freeglut libXi libXxf86vm _directfb2"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="An output device which depends on xinelib"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include


  export ADD_LD_FLAGS="$(pkg-config --libs x11 glu gl glx glew)"
  cd .. && make all
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" install
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/
  cp  ${PKG_DIR}/conf/* ${INSTALL}/storage/.config/vdropt-sample/

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/xineliboutput-config.zip" storage
}
