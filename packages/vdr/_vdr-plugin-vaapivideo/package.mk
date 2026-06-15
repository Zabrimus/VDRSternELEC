# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vaapivideo"
PKG_VERSION="eaa619deea5300e561cac93c46899c2b735a2be7"
PKG_SHA256="c485f29551dfa31508e36ae0abc9e79834a3e2dbfbaed11ef729df7bc14b9f50"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/dnehring7/vdr-plugin-vaapivideo"
PKG_URL="https://github.com/dnehring7/vdr-plugin-vaapivideo/archive/${PKG_VERSION}.zip"
PKG_BRANCH="main"
PKG_SOURCE_DIR="vdr-plugin-vaapivideo-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr ffmpeg libva libdrm alsa vdr-helper"
# PKG_DEPENDS_TARGET="toolchain _vdr libglvnd nvidia glm alsa freetype ffmpeg libdrm mesa libva _xcb-util-wm libxcb glu libXi libXrandr libXrender libXext libXxf86vm vdr-helper"
PKG_DEPENDS_CONFIG="_vdr libva"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper libva"
PKG_LONGDESC="Hardware-accelerated video output for VDR using VAAPI decode, DRM atomic modesetting, and ALSA audio. "
# PKG_MAKE_OPTS_TARGET="CUVID=$(cat $(get_build_dir ffmpeg)/config.h | grep CUVID | cut -d ' ' -f 3)"
# PKG_MAKEINSTALL_OPTS_TARGET="CUVID=$(cat $(get_build_dir ffmpeg)/config.h | grep CUVID | cut -d ' ' -f 3)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/vaapivideo

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
