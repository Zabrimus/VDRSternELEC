# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-osd2web"
PKG_VERSION="4f834066d129c0c1a373ebb7b4403304a7eaff30"
PKG_SHA256="3b374daf26e16ee283cb01cdbf1feec3696d7d02fc56e11d324c0f117c206d65"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/vdr-plugin-osd2web"
PKG_URL="https://github.com/horchi/vdr-plugin-osd2web/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-osd2web-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libwebsockets libexif vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} osd2web
}
