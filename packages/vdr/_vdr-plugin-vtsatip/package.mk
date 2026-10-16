# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vtsatip"
PKG_VERSION="fa01ece444952c6a2f7ca1beb2eacf3abf313dfa"
PKG_SHA256="257d1752124d039db92eb9a30cbffee0f095d65a27d43315e773e3d7435222ff"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rellla/vdr-plugin-vtsatip"
PKG_URL="https://github.com/rellla/vdr-plugin-vtsatip/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-vtsatip-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="vtsatip - SAT>IP plugin for VDR with the behaviour of vtuner-ng"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
