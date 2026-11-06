# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-hyperion"
PKG_VERSION="2f517ddea1e4890aba046af58a237720cc684828"
PKG_SHA256="bf2fe3849a476820ac2b0c3d8d298ed53da3e31a2cd243c775dda6403ff211fe"
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
