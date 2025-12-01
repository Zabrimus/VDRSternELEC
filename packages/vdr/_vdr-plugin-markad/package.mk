# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-markad"
PKG_VERSION="011da05730e8fac91f1ea949798479f73cc43487"
PKG_SHA256="7bc5093ed94d4645107e2dd05e0754d6b103254756f02208695d6755e95a7d79"
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
