# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-xineliboutput"
PKG_VERSION="2.2.0+git20211212-2"
PKG_SHA256="c4e8d440f9ae37986021e192fdcbb27681ca06d5033b73b9bca6f824b96a6e0c"
PKG_LICENSE="GPL"
PKG_SITE="https://sourceforge.net/projects/xineliboutput"
PKG_URL="https://salsa.debian.org/vdr-team/vdr-plugin-xineliboutput/-/archive/debian/${PKG_VERSION}/vdr-plugin-xineliboutput-debian-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="vdr-plugin-xineliboutput-debian-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr glibc _xine-lib libX11 mesa _xcb-util-wm libxcb _freeglut libXi libXxf86vm _directfb2 vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="An output device which depends on xinelib"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

make_target() {
  cd .. && make all
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample
  cp  ${PKG_DIR}/conf/* ${INSTALL}/storage/.config/vdropt-sample/

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
