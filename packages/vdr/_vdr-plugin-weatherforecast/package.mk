# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-weatherforecast"
PKG_VERSION="842b086b65a7116a7aa5a2142097a2b2220f4c3c"
PKG_SHA256="9f9e8e58952655b9dda514bee993dff9ba2fb678f7aa1d71f367805c7c9d9db5"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-weatherforecast"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-weatherforecast/archive/842b086b65a7116a7aa5a2142097a2b2220f4c3c.zip"
PKG_SOURCE_DIR="vdr-plugin-weatherforecast-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-skindesigner vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _vdr-plugin-skindesigner"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
