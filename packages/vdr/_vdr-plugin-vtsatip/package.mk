# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vtsatip"
PKG_VERSION="e0bf93260e83457d4136a94441fa23f9f1efd181"
PKG_SHA256="2b96e15874aa11904a98ba2acf36488ab4d43ccf282811b26ee40d6cf0ac96ab"
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
