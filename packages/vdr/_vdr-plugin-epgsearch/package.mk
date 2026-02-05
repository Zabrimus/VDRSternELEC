# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epgsearch"
PKG_VERSION="1af38eaf84b5cfc53726446dc4a0c5f2f5f52cd7"
PKG_SHA256="c059a839c88c5cfac672f8aa2ebfd03a95e1c94800e454a7031532c12e2c383c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-epgsearch"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-epgsearch/archive/${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr pcre2 vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="EPGSearch is a plugin for the Video-Disc-Recorder (VDR)."
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} epgsearch
}
