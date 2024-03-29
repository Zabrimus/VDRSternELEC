# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-boblight"
PKG_VERSION="c2fed8e3559331480bbae795a4e3ca6c75d6a4c5"
PKG_SHA256="ca7b116267762a111016b6c10a128c24a7d628ff8104a7317e0be0fff0a6b8af"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-vdrboblight"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-vdrboblight/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-boblight-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _boblight vdr-helper"
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
