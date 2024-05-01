# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-control"
PKG_VERSION="f6f7cb55605c1c5237dc68655eca5f6a5a843c9f"
PKG_SHA256="c5abb898599eabfc1321bb81a553c3b927e2af4dad32ed9715c5533363271cb2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control"
PKG_URL="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-control-${PKG_VERSION}"
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
