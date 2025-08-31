# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddrm"
PKG_VERSION="f902347cc3681ad461657f91889804af72843b58"
PKG_SHA256="b5506e94e54fb479ee76aa22044cddf9a08ac5e63cc61a5755d615ace144911d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jojo61/vdr-plugin-softhdcuvid"
PKG_URL="https://github.com/jojo61/vdr-plugin-softhdcuvid/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-softhdcuvid-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr mesa glu glew _freeglut libxcb libX11 _xcb-util-wm libplacebo vdr-helper"
PKG_DEPENDS_CONFIG="_vdr libplacebo"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="VDR Output Device (softhdddrm"
PKG_BUILD_FLAGS="+speed"

post_unpack() {
  rm -f ${PKG_DIR}/patches/interlaced_frame.patch

  if [ "${ARCH}" = "x86_64" ] && [ "${DISTRO}" = "LibreELEC" ] && [ "${OS_VERSION:0:2}" = "12" ]; then
  	 mkdir -p ${PKG_DIR}/patches
     cp ${PKG_DIR}/le12/interlaced_frame.patch ${PKG_DIR}/patches/interlaced_frame.patch
  fi
}

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
