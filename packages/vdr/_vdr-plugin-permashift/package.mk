# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-permashift"
PKG_VERSION="afec850e8a5ed1ad215714f26bd94ad1dd0a028a"
PKG_SHA256="9b79ad2952ca75758b760dabba4833de80af5ed5ac1d4246802a5f05564c7dc1"
PKG_LICENSE="GPL"
PKG_SITE="https://ein-eike.de/vdr-plugin-permashift-english/"
PKG_URL="https://github.com/eikesauer/Permashift/archive/afec850e8a5ed1ad215714f26bd94ad1dd0a028a.zip"
PKG_SOURCE_DIR="Permashift-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="Permanent timeshift plugin for Video Disc Recorder (VDR)"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/${VDR_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make all
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
  mkdir -p ${INSTALL}${VDR_PREFIX}/config/
  zip -qrum9 "${INSTALL}${VDR_PREFIX}/config/permashift-sample-config.zip" storage
}
