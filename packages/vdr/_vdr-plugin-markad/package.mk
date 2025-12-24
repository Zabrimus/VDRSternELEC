# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-markad"
PKG_VERSION="106b63f086ec8091c0af95fd40aeb6da48e40fec"
PKG_SHA256="34dced8d4d737b123633343a7c0c6cdff0c09b2b918ca9a37e4bd8d49158dd49"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/kfb77/vdr-plugin-markad"
PKG_URL="https://github.com/kfb77/vdr-plugin-markad/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-markad-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr ffmpeg vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN} markad
}
