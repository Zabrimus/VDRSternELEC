# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-skin-anthra-fst"
PKG_VERSION="7aee1603acef815e4dd16325751e6ea4d5637dd81"
PKG_SHA256="6a08f0bba5114a44fc74b6b8a442be7b71b05f44d48d67d15b1daf8baf07ce54"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/unf/vdr-skin-anthra-fst"
PKG_URL="https://github.com/unf/vdr-skin-anthra-fst/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-skin-anthra-fst-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-text2skin _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="anthra is the dark, anthracite skin family for text2skin, designed from 2010 to 2014 by Tomas Saxer on vdr-portal.de"
PKG_BUILD_FLAGS="+speed"
PKG_TOOLCHAIN="make"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
