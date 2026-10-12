# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dvbapi"
PKG_VERSION="47a80f7c37d0d19a50c41941aec4d7ef7bdb3c0f"
PKG_SHA256="f30d69d18224175110354572979c9e68b2b47889fc1b15de6f949779ec0b7936"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/manio/vdr-plugin-dvbapi"
PKG_URL="https://github.com/manio/vdr-plugin-dvbapi/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr libdvbcsa vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR dvbapi plugin for use with OSCam"
PKG_MAKE_OPTS_TARGET="LIBDVBCSA_NEW=1"
PKG_MAKEINSTALL_OPTS_TARGET="LIBDVBCSA=1"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
