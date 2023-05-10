# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-targavfd"
PKG_VERSION="36dda7933465fd556b3b0ec848923aebe15fbe87"
PKG_SHA256="552425ae30ff6483aa10300b3b92795a7ab883a9d679dc115918af0de323c1cc"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-targavfd"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-targavfd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-targavfd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libusb vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
