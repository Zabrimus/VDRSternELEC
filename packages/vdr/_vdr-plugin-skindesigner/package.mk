# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skindesigner"
PKG_VERSION="89422271f3a9e6d83d2eaf2b235533ac61c3e1f7"
PKG_SHA256="f231f9fb33a639451ea9b743aa06dc791d19d2c107e825ab74772e135a0d2d23"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/skindesigner.git"
PKG_URL="https://gitlab.com/kamel5/skindesigner/-/archive/${PKG_VERSION}/skindesigner-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr cairo _librsvg _fonts pango shared-mime-info vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _vdr-plugin-skindesigner _librsvg cairo shared-mime-info pango"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="A VDR skinning engine that displays XML based Skins"
PKG_MAKE_OPTS_TARGET="SKINDESIGNER_SCRIPTDIR=/storage/.config/vdropt/plugins/skindesigner/scripts"
PKG_MAKEINSTALL_OPTS_TARGET="PLGRES_DIR=${INSTALL}/storage/.config/vdropt-sample/plugins/skindesigner SKINDESIGNER_SCRIPTDIR=/storage/.config/vdropt/plugins/skindesigner/scripts"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

make_target() {
	DESTDIR="${INSTALL}" make libskindesignerapi install-subprojects
	DESTDIR="${INSTALL}" make
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}

  # ugly hack. A symbolic link to libskindesignerapi is missing. Further investigation is needed!
    (
     cd ${INSTALL}/usr/local/lib/vdr/
  	 ln -s libskindesignerapi.so libskindesignerapi.so.0
    )

  # copy libskindesignerapi.pc to install directory
  cp ${PKG_DIR}/addinstall/libskindesignerapi.pc ${INSTALL}/usr/local/lib/pkgconfig
}

