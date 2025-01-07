# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinflatplus"
PKG_VERSION="7dad6ab0cdcbdaeed3fa4c40870bb23288ad722d"
PKG_SHA256="54b004efad3831355908697b3301d48d1d0e3dc4778cc71c6398c14b566e4cc4"
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
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
