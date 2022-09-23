# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice"
PKG_VERSION="35b4cac79b82b876383de94503d0c28f50418322"
PKG_SHA256="d62907b475e1464c7d9afd2b9b9a9b64081eb5d1d0cd64cbdc876cbb0f46af87"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/ua0lnj/vdr-plugin-softhddevice"
PKG_URL="https://github.com/ua0lnj/vdr-plugin-softhddevice/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-softhddevice-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libglvnd nvidia glm alsa freetype ffmpeg libdrm mesa libva _xcb-util-wm _libxcb glu libXi libXxf86vm"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="A software and GPU emulated UHD output device plugin for VDR."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr

  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" install
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/softhddevice

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
  zip -qrum9 "${INSTALL}/usr/local/config/softhddevice-sample-config.zip" storage
}
