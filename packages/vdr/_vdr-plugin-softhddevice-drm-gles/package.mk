# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice-drm-gles"

PKG_VERSION="408d27f0e21c091df97674cedd677e34642acd2a"
PKG_SHA256="14efd1b798ac3ca2454e8607a325ec625b7df70216bdb5f3bbd0d707898bec52"
PKG_SITE="https://github.com/rellla/vdr-plugin-softhddevice-drm-gles"
PKG_URL="https://github.com/rellla/vdr-plugin-softhddevice-drm-gles/archive/${PKG_VERSION}.zip"
PKG_BRANCH="drm-atomic-gles"
PKG_LICENSE="GPL"
PKG_SOURCE_DIR="vdr-plugin-softhddevice-drm-gles-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm vdr-helper mesa"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR Output Device (softhddevice-drm-gles)"
PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
  export GIT_DESCRIBE="-$(echo ${PKG_VERSION:0:7})"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
