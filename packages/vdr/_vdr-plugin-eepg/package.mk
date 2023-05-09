# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-eepg"
PKG_VERSION="6be7f2ee644aa33bd6e6e038548be8a85514272e"
PKG_SHA256="50298adb6dc0826ffc93a9f87d7dc110ffdd4bfecab94690ea77c6477cff1cc0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-eepg"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-eepg/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_SOURCE_DIR="vdr-plugin-eepg-${PKG_VERSION}"
PKG_LONGDESC="This plugin parses the Extended EPG data which is send by providers on their portal channels."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
