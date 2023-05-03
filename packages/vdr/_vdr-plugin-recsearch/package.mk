# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-recsearch"
PKG_VERSION="071ca720d59638dccd3723292c5970ee8352ad30"
PKG_SHA256="cd53c7335afd5e11375ead4768af16a78bcc9c196961793dfffc1fed531c5ef9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/flensrocker/vdr-plugin-recsearch"
PKG_URL="https://github.com/flensrocker/vdr-plugin-recsearch/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-recsearch-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr"
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
  zip -qrum9 "${INSTALL}/usr/local/config/recsearch-sample-config.zip" storage
}
