# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-ac3mode"
PKG_VERSION="b703a1d907749fae4560ef2125083013a2a5a3f0"
PKG_SHA256="df5ed34cd40ddbaf0ead197746b05ab68e3e180557935fc141d6e9aeaf85e8be"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-ac3mode"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-ac3mode/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-ac3mode-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
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
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
