# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice-drm-gles"

PKG_VERSION="4306716a10f4a5e7e6ecc5a92f92707f64f8f93c"
PKG_SHA256="af9d3a9724cb94094e16940df86514b59293266dc31a62abd5f73f90bacc3a93"
PKG_SITE="https://github.com/rellla/vdr-plugin-softhddevice-drm-gles"
PKG_URL="https://github.com/rellla/vdr-plugin-softhddevice-drm-gles/archive/${PKG_VERSION}.zip"
PKG_BRANCH="drm-atomic-gles"
PKG_LICENSE="GPL"
PKG_SOURCE_DIR="vdr-plugin-softhddevice-drm-gles-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm vdr-helper mesa"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="VDR Output Device (softhddevice-drm-gles)"
PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
