# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-femon"
PKG_VERSION="ff59839f7d5246b286d12352c3e67fc96f698e9a"
PKG_SHA256="1a261a364ea28a4389b441b6f80e7c6fd410631d5d3c541f74c50d63dc6c5541"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rofafor/vdr-plugin-femon"
PKG_URL="https://github.com/rofafor/vdr-plugin-femon/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-femon-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
