# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-webbridge"
PKG_VERSION="32c3030f655d172c861c43af9424dff848085a30"
PKG_SHA256="c709f1394282ae1f327f1e9accbadff054607cc0fbc38ccf1b1b0688432085ed"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-webbridge"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-webbridge/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_SOURCE_DIR="vdr-plugin-webbridge-${PKG_VERSION}"
PKG_LONGDESC="Bridge between websockets and VDR SVDRP"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
