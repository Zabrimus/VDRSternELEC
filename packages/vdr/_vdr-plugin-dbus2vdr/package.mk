# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dbus2vdr"
PKG_VERSION="119b4e8f02b39d37af6d41365208cc44e8cd986d"
PKG_SHA256="f34197b71f402d19effa2847fce3872dad1aff0aa321aa129e40f86f659b7ba2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/flensrocker/vdr-plugin-dbus2vdr"
PKG_URL="https://github.com/flensrocker/vdr-plugin-dbus2vdr/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-dbus2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libpngpp dbus glib libjpeg-turbo"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr _libpngpp)"
PKG_LONGDESC="This plugin will expose some methods via DBus to control the vdr."
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
  LIBPNGPP_DIR=$(get_build_dir _libpngpp)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/${VDR_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include:${LIBPNGPP_DIR}

  make
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" install
}

post_makeinstall_target() {
  # remove unneeded
  rm -Rf ${INSTALL}/etc/init

  # move other files
  mkdir -p ${INSTALL}${VDR_PREFIX}/bin
  mv ${INSTALL}/usr/share/vdr-plugin-dbus2vdr/* ${INSTALL}${VDR_PREFIX}/bin
  cp $(get_pkg_directory _vdr-plugin-dbus2vdr)/config/vdr-dbus-send.sh ${INSTALL}${VDR_PREFIX}/bin

  cp $(get_pkg_directory _vdr-plugin-dbus2vdr)/config/de.tvdr.vdr.conf ${INSTALL}/etc/dbus-1/system.d/de.tvdr.vdr.conf

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
  zip -qrum9 "${INSTALL}${VDR_PREFIX}/config/dbus2vdr-sample-config.zip" storage
}
