# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vdrsternelec"
PKG_VERSION="65088db571121bf01e0ecdb8f8a0eb39d4ae353e"
PKG_SHA256="ba093588dd344615156dc85b718b720231e519113311d7662eff4b5f6909c412"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rellla/vdr-plugin-vdrsternelec"
PKG_URL="https://github.com/rellla/vdr-plugin-vdrsternelec/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-vdrsternelec-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr curl samba vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="vdrsternelec - update VDR*ELEC from release servers, GitHub, Samba shares or local directories"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  # copy configuration files
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/vdrsternelec
  cp $(get_build_dir _vdr-plugin-vdrsternelec)/servers.conf.example ${INSTALL}/storage/.config/vdropt-sample/plugins/vdrsternelec/servers.conf

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
