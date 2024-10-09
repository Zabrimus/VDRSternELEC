# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinelchihd"
PKG_VERSION="baadf3b3ee8e77ca90cbfb810169c51f1b64f09f"
PKG_SHA256="18e0365c2093bf587132e7925a0dc4c1839d31bcdc23a66232d5ffab96d32f23"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FireFlyVDR/vdr-plugin-skinelchihd"
PKG_URL="https://github.com/FireFlyVDR/vdr-plugin-skinelchihd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-skinelchihd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="This plugin parses the Extended EPG data which is send by providers on their portal channels."
PKG_MAKE_OPTS_TARGET="IMAGELIB=graphicsmagick"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
