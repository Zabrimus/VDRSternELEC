# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice-drm-gles"

PKG_VERSION="8d5eb26812f97d332113757ed122fe0c800d61e4"
PKG_SHA256="09bb8c0a3d720c9d8e8ca0db4162f3f8678dae23e717ab861c25b45f6c38345d"
PKG_SITE="https://github.com/rellla/vdr-plugin-softhddevice-drm"
PKG_URL="https://github.com/rellla/vdr-plugin-softhddevice-drm/archive/${PKG_VERSION}.zip"
PKG_BRANCH="drm-atomic-gles"
PKG_LICENSE="GPL"
PKG_SOURCE_DIR="vdr-plugin-softhddevice-drm-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm mesa"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="VDR Output Device (softhddevice-drm-gles)"
PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
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
  zip -qrum9 "${INSTALL}/usr/local/config/softhddevice-drm-gles-sample-config.zip" storage
}
