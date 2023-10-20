# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-osd2web"
PKG_VERSION="e35a57f051ab1228987d9ce0bea7a40fd4dfec74"
PKG_SHA256="8df14424b56f16538f3903b78017a8896d99d7ff342b2fcafa28af08d5287006"
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
