# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vtsatip"
PKG_VERSION="d240a1bb1a94b529d802a269c03a8a7466f01ec2"
PKG_SHA256="831a26d9ae1e032929a57077cbd5fd57062c128bac6d77bd143436862bb21063"
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
