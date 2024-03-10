# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-satip"
PKG_VERSION="fa3dca05bbc4f7c27a5867d6eb50f16d11e9aa79"
PKG_SHA256="7e678a55fc97b03a2bff8f00ab85bb96e72ed6c849ca5be40b1831711b200ded"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/wirbel-at-vdr-portal/vdr-plugin-satip"
PKG_URL="https://github.com/wirbel-at-vdr-portal/vdr-plugin-satip/archive/${PKG_VERSION}.zip"
PKG_BRANCH="wirbel"
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
