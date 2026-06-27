# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice"
PKG_VERSION="68cc777c87c8aab8f1f398133d4931d868cc42b6"
PKG_SHA256="8adb7baf1129fda8e86b9e745af85cce6d1e448d370c9478fe82b4b8b1a9dfe7"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/ua0lnj/vdr-plugin-softhddevice"
PKG_URL="https://github.com/ua0lnj/vdr-plugin-softhddevice/archive/${PKG_VERSION}.zip"
PKG_BRANCH="latest"
PKG_SOURCE_DIR="vdr-plugin-softhddevice-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libglvnd nvidia glm alsa freetype ffmpeg libdrm mesa libva _xcb-util-wm libxcb glu libXi libXrandr libXrender libXext libXxf86vm vdr-helper"
PKG_DEPENDS_CONFIG="_vdr libva"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper libva"
PKG_LONGDESC="A software and GPU emulated UHD output device plugin for VDR."
PKG_MAKE_OPTS_TARGET="CUVID=$(cat $(get_build_dir ffmpeg)/config.h | grep CUVID | cut -d ' ' -f 3)"
PKG_MAKEINSTALL_OPTS_TARGET="CUVID=$(cat $(get_build_dir ffmpeg)/config.h | grep CUVID | cut -d ' ' -f 3)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/softhddevice

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
