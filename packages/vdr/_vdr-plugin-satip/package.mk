# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-satip"
PKG_VERSION="915e930407bf5c60099e6d5176108bb6a2da52b0"
PKG_SHA256="bb9da80c62bbadb59f7cb15f3c9a84f715da777a10cc16c7e70afe095b21b21b"
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
