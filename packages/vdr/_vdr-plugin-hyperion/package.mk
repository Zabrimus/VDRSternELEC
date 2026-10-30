# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-hyperion"
PKG_VERSION="55c0d6e3665b3303fb2d58982e2dddd21ed2cc71"
PKG_SHA256="16918e40618eff02525d016475bb61228e020e421dd1e3c77f3f09f015bcef45"
PKG_LICENSE="AGPL"
PKG_SITE="https://github.com/rellla/vdr-plugin-hyperion"
PKG_URL="https://github.com/rellla/vdr-plugin-hyperion/archive/${PKG_VERSION}.zip"
PKG_BRANCH="main"
PKG_SOURCE_DIR="vdr-plugin-hyperion-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="hyperion - ambient light with Hyperion.ng (needs an output plugin with the AmbientImage service, e.g. drmdevice)"
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
