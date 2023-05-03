# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-boblight"
PKG_VERSION="ed0aa9c57c26f63b69cbfaa7f61d365d05a3dd52"
PKG_SHA256="9604be4158d15ad2e6b61ee220c406208b434c0d0d1b11198baca0a79d453fa6"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-vdrboblight"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-vdrboblight/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-vdrboblight-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _boblight"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"

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
  zip -qrum9 "${INSTALL}/usr/local/config/boblight-sample-config.zip" storage
}
