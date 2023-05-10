# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-satip"
PKG_VERSION="02a842f95a09a74d7eba90648c97693638007141"
PKG_SHA256="daf3b6024274e3216345e6d48076641f5388bbc28ab4d56464470b28ea1755ef"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rofafor/vdr-plugin-satip"
PKG_URL="https://github.com/rofafor/vdr-plugin-satip/archive/${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr curl tinyxml vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="This is an SAT>IP plugin for the Video Disk Recorder (VDR)."
PKG_MAKE_OPTS_TARGET="SATIP_USE_TINYXML=1"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
