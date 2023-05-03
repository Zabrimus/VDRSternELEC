# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_vdr-plugin-robotv"
PKG_VERSION="4fe38e0ffa1014f34eeb941aada6fe0d31f72707"
PKG_SHA256="e36783e0a15edcd33eb449569980d59abb51a805ea987c2c5ba5ff689a549dee"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/pipelka/vdr-plugin-robotv"
PKG_URL="https://github.com/pipelka/vdr-plugin-robotv/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr avahi"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-robotv-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="RoboTV is a Android TV based frontend for VDR."

post_unpack() {
  mv ${PKG_BUILD}/CMakeLists.txt ${PKG_BUILD}/Original-CMakeLists.txt
}

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
  zip -qrum9 "${INSTALL}/usr/local/config/robotv-sample-config.zip" storage
}
