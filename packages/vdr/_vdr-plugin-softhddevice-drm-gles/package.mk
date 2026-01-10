# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice-drm-gles"

PKG_VERSION="9bc3dc806695a449771041bfed79458d83f047be"
PKG_SHA256="041a4587c1de8cf85724e19f4a739628c68123a7b4d76521960f0f9f8157d79e"
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
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
