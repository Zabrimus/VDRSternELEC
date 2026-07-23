# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-satip"
PKG_VERSION="4ab9d85f6c417d03109bc5694eede287bf6c8b60"
PKG_SHA256="bb9fd01a583730b8894920b6300752cdebd7e39679a121be8118004f216347be"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FireFlyVDR/vdr-plugin-satip"
PKG_URL="https://github.com/FireFlyVDR/vdr-plugin-satip/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr curl tinyxml2 _librepfunc vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="This is an SAT>IP plugin for the Video Disk Recorder (VDR)."
PKG_MAKE_OPTS_TARGET="SATIP_USE_TINYXML2=1"
PKG_SOURCE_DIR="vdr-plugin-satip-${PKG_VERSION}"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
