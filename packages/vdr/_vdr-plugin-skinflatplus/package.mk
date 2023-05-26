# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinflatplus"
PKG_VERSION="5f5dc5d6722ae9fda9f833c19dfb7cbefcab7406"
PKG_SHA256="d600847745a25cb4ec9ed2c36f183e2c55fb88f02123c30aa6f86fc1ae3f2350"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MegaV0lt/vdr-plugin-skinflatplus"
PKG_URL="https://github.com/MegaV0lt/vdr-plugin-skinflatplus/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-skinflatplus-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_MAKE_OPTS_TARGET="IMAGELIB=graphicsmagick"
PKG_MAKEINSTALL_OPTS_TARGET="SKINFLATPLUS_WIDGETDIR=/storage/.config/vdropt-sample/plugins/skinflatplus"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
