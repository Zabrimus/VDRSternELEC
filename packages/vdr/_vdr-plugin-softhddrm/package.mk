# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddrm"
PKG_VERSION="4c48e911564b50d52042071792617ed09d927365"
PKG_SHA256="6da3a572ec565c8e61d176bb56aa72016ba7c2794c4c99d5e1fd0cf2594ab0b9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jojo61/vdr-plugin-softhdcuvid"
PKG_URL="https://github.com/jojo61/vdr-plugin-softhdcuvid/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-softhdcuvid-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr mesa glu glew _freeglut libxcb libX11 _xcb-util-wm libplacebo vdr-helper"
PKG_DEPENDS_CONFIG="_vdr libplacebo"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="VDR Output Device (softhdddrm"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

  # build configuration
  export VAAPI=0
  export CUVID=0
  export DRM=1
  export LIBPLACEBO=0
  export LIBPLACEBO_GL=1
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/softhddrm

  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} "softhddrm"
}
