# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-restfulapi"
PKG_VERSION="fedba792188f4765bdf74d3edecf8f62dcb84eb9"
PKG_SHA256="178ff2f5853fe4bb032caa8a8227e444f7dcf58662fbf320ea309782869ea38a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/yavdr/vdr-plugin-restfulapi"
PKG_URL="https://github.com/yavdr/vdr-plugin-restfulapi/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr cxxtools vdr-helper _vdr-plugin-wirbelscan"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-restfulapi-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper) $(get_pkg_directory _vdr-plugin-wirbelscan)"
PKG_DEPENDS_UNPACK="vdr-helper _vdr-plugin-wirbelscan"
PKG_LONGDESC="Allows to access many internals of the VDR via a restful API."
PKG_MAKE_OPTS_TARGET="USE_LIBMAGICKPLUSPLUS=0"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig

  cp $(get_build_dir _vdr-plugin-wirbelscan)/wirbelscan_services.h ${PKG_BUILD}/wirbelscan/
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
