# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vdrsternelec"
PKG_VERSION="3ed280a588f1c6ecf6594b7d5be55177b667f780"
PKG_SHA256="d1da10aee996e1e0c57734b0e6427521b27db4bc177f7fe44726a8465b047861"
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
