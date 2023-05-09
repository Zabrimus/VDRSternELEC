# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dvbapi"
PKG_VERSION="d0fb10b0bc67ad172e7b383f5da2de9d87f74d7f"
PKG_SHA256="a656ca51c5634145e19296733bed9aa06b6d4e665819641a2daeab37705e4025"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/manio/vdr-plugin-dvbapi"
PKG_URL="https://github.com/manio/vdr-plugin-dvbapi/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr _libdvbcsa vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="VDR dvbapi plugin for use with OSCam"
PKG_MAKE_OPTS_TARGET="LIBDVBCSA_NEW=1"
PKG_MAKEINSTALL_OPTS_TARGET="LIBDVBCSA=1"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
