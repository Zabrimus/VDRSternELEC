# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice"
PKG_VERSION="6e82ac99214b43c24ecc382e4b7e6ccf953b2cfb"
PKG_SHA256="cd022d1342152a90e5d7ae622bac7e412496d6e022e812a6be5c2e3c9d84b527"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/ua0lnj/vdr-plugin-softhddevice"
PKG_URL="https://github.com/ua0lnj/vdr-plugin-softhddevice/archive/${PKG_VERSION}.zip"
PKG_BRANCH="latest"
PKG_SOURCE_DIR="vdr-plugin-softhddevice-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libglvnd nvidia glm alsa freetype ffmpeg libdrm mesa libva _xcb-util-wm libxcb glu libXi libXxf86vm vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="A software and GPU emulated UHD output device plugin for VDR."
PKG_MAKE_OPTS_TARGET="CUVID=$(cat $(get_build_dir ffmpeg)/config.h | grep CUVID | cut -d ' ' -f 3)"
PKG_MAKEINSTALL_OPTS_TARGET="CUVID=$(cat $(get_build_dir ffmpeg)/config.h | grep CUVID | cut -d ' ' -f 3)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/softhddevice

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
