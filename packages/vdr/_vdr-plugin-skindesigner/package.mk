# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skindesigner"
PKG_VERSION="1.2.18"
PKG_SHA256="e58ca15b0ddd846f1415f857cac995d154b528bab275a45a8008d874a005b35b"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/skindesigner"
PKG_URL="https://gitlab.com/kamel5/skindesigner/-/archive/${PKG_VERSION}/skindesigner-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain _vdr cairo _librsvg _fonts"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="A VDR skinning engine that displays XML based Skins"
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

  export PKG_CONFIG_PATH=${VDR_DIR}:"$(get_build_dir _vdr-plugin-skindesigner)":"${SYSROOT_PREFIX}${VDR_PREFIX}/lib/pkgconfig":"$(get_install_dir shared-mime-info)/usr/share/pkgconfig":"$(get_install_dir pango)/usr/lib/pkgconfig":"$(get_install_dir libXft)/usr/lib/pkgconfig":${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include
  export PATH="${SYSROOT_PREFIX}${VDR_PREFIX}/bin":$PATH
  SKINDESIGNER_SCRIPTDIR="/storage/.config/vdropt/plugins/skindesigner/scripts"

  make SKINDESIGNER_SCRIPTDIR="${SKINDESIGNER_SCRIPTDIR}" INCDIR="${VDR_PREFIX}/include"
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  PLGRES_DIR="${INSTALL}/storage/.config/vdropt-sample/plugins/skindesigner"
  SKINDESIGNER_SCRIPTDIR="/storage/.config/vdropt/plugins/skindesigner/scripts"
  SKINDESIGNER_DIR=$(get_install_dir _vdr-plugin-skindesigner)

  make PREFIX="${VDR_PREFIX}" DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" PLGRESDIR="${PLGRES_DIR}" SKINDESIGNER_SCRIPTDIR="${SKINDESIGNER_SCRIPTDIR}" install

  # ugly hack. Similar to the one in _vdr
  mkdir -p ${SKINDESIGNER_DIR}${VDR_PREFIX}/${VDR_PREFIX}
  cd ${SKINDESIGNER_DIR}${VDR_PREFIX}/${VDR_PREFIX}
  ln -s ../../include include
  cd $(get_build_dir _vdr_plugin_skindesigner)
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
  zip -qrum9 "${INSTALL}${VDR_PREFIX}/config/skindesigner-sample-config.zip" storage
}
