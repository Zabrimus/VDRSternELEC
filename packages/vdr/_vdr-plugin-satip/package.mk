# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-satip"
PKG_VERSION="a9fba5323f1fdce030b1de06c7c7549a4925ccb8"
PKG_SHA256="35b7eccf2c22cf414818f31bb992b5e407ebc34c34112b3f23bdf17570ed221c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FireFlyVDR/vdr-plugin-satip"
PKG_URL="https://github.com/FireFlyVDR/vdr-plugin-satip/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr curl tinyxml _librepfunc vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="This is an SAT>IP plugin for the Video Disk Recorder (VDR)."
PKG_MAKE_OPTS_TARGET="SATIP_USE_TINYXML=1"
PKG_SOURCE_DIR="vdr-plugin-satip-${PKG_VERSION}"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
