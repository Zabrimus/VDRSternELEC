# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epgsearch"
PKG_VERSION="e12642248c8ad2de70bec4cafaac06dc6adf5d04"
PKG_SHA256="0fc948ed249e61122a329c2478851b97fb56c5cf3d4262261eb44473bf53c2b4"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-epgsearch"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-epgsearch/archive/${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr pcre vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="EPGSearch is a plugin for the Video-Disc-Recorder (VDR)."
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} epgsearch
}
