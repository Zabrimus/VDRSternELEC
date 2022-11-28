# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice-drm"

if [ "${PROJECT}" = "Amlogic" ] && [ "${DEVICE}" = "AMLGX" ]; then
	PKG_VERSION="cbccef7cc37c3122c75f58000a50227fe468ca45"
	PKG_SHA256="476862b1f127a3583ce6d4544b72668ced48c6379ede2f8598977e41ad8c60e7"
	PKG_SITE="https://github.com/zillevdr/vdr-plugin-softhddevice-drm"
	PKG_URL="https://github.com/zillevdr/vdr-plugin-softhddevice-drm/archive/${PKG_VERSION}.zip"
else
	PKG_VERSION="fcfe125b7be0893b46ca9dfcaa327098df26795d"
	PKG_SHA256="f7ddbad1753f311a34824603c251438b98c3186aa9fb404aa8d288850228aad0"
    PKG_SITE="https://github.com/rellla/vdr-plugin-softhddevice-drm"
    PKG_URL="https://github.com/rellla/vdr-plugin-softhddevice-drm/archive/${PKG_VERSION}.zip"
    PKG_BRANCH="drm-atomic-gles"
fi

PKG_LICENSE="GPL"

PKG_SOURCE_DIR="vdr-plugin-softhddevice-drm-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm mesa"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="VDR Output Device (softhddevice-drm)"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make GLES=1
}

makeinstall_target() {
  LOC_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)
  LIB_DIR=${LOC_DIR}/../../lib/vdr
  VDRDIR=${VDR_DIR}

  make VDRDIR=${VDR_DIR} LOCDIR="${LOC_DIR}" LIBDIR="${LIB_DIR}" GLES=1 install
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
  zip -qrum9 "${INSTALL}/usr/local/config/softhddevice-drm-sample-config.zip" storage
}
