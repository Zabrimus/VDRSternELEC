# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epgsearch"
PKG_VERSION="ae385f969519e30a3df5f3576dabf18470fb373a"
PKG_SHA256="cc2e3bb2d53794c782a5780b6d55676f2690204fbb977e0f82f9b2c1def6a3b8"
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
