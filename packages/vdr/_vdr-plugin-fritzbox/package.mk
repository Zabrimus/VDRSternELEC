# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-fritzbox"
PKG_VERSION="368a393a3e56f49d5f8b3c4411acf511e1796690"
PKG_SHA256="164c622ec32a4dbe2e448da94ad03ffb252f05602a4c1b31239ddf2082b39a4c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jowi24/vdr-fritz"
PKG_URL="https://github.com/jowi24/vdr-fritz/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-fritz-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libconvpp _libfritzpp _liblogpp _libnetpp boost"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}

pre_make_target() {
   # reorganize build directory
   FRITZ_DIR=$(get_build_dir _vdr-plugin-fritzbox)
   cd ..

   rm -rf "${FRITZ_DIR}/libconv++" "${FRITZ_DIR}/libfritz++" "${FRITZ_DIR}/liblog++" "${FRITZ_DIR}/libnet++"
   ln -s $(get_build_dir _libnetpp) ${FRITZ_DIR}/libnet++
   ln -s $(get_build_dir _libconvpp) ${FRITZ_DIR}/libconv++
   ln -s $(get_build_dir _liblogpp) ${FRITZ_DIR}/liblog++
   ln -s $(get_build_dir _libfritzpp) ${FRITZ_DIR}/libfritz++
}

make_target() {
  cd $(get_build_dir _vdr-plugin-fritzbox)

  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/${VDR_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" install
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox
  cp -r $(get_build_dir _vdr-plugin-fritzbox)/templates/on-call.sh ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox
  chmod +x ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox/on-call.sh

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
  zip -qrum9 "${INSTALL}${VDR_PREFIX}/config/fritzbox-sample-config.zip" storage
}
