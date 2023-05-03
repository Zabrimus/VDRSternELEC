# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-eepg"
PKG_VERSION="6be7f2ee644aa33bd6e6e038548be8a85514272e"
PKG_SHA256="50298adb6dc0826ffc93a9f87d7dc110ffdd4bfecab94690ea77c6477cff1cc0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-eepg"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-eepg/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_SOURCE_DIR="vdr-plugin-eepg-${PKG_VERSION}"
PKG_LONGDESC="This plugin parses the Extended EPG data which is send by providers on their portal channels."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/eepg-sample-config.zip" storage
}
