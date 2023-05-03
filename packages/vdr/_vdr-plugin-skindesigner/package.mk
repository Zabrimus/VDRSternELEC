# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skindesigner"
PKG_VERSION="766bfeff7bd03a4ca9469ead46f5fa38fd5f231a"
PKG_SHA256="6f97cbc19988ec9a858991adcef60aebcf8ae424c7dd1f2e4a9e4b97ce715af9"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/skindesigner.git"
PKG_URL="https://gitlab.com/kamel5/skindesigner/-/archive/${PKG_VERSION}/skindesigner-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr cairo _librsvg _fonts libXext pango shared-mime-info"
PKG_DEPENDS_CONFIG="_vdr _vdr-plugin-skindesigner _librsvg cairo shared-mime-info pango"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="A VDR skinning engine that displays XML based Skins"
PKG_MAKE_OPTS_TARGET="SKINDESIGNER_SCRIPTDIR=/storage/.config/vdropt/plugins/skindesigner/scripts"
PKG_MAKEINSTALL_OPTS_TARGET="PLGRES_DIR=${INSTALL}/storage/.config/vdropt-sample/plugins/skindesigner SKINDESIGNER_SCRIPTDIR=/storage/.config/vdropt/plugins/skindesigner/scripts"

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
  zip -qrum9 "${INSTALL}/usr/local/config/skindesigner-sample-config.zip" storage
}
