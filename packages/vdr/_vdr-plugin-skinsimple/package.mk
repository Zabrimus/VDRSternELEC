# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinsimple"
PKG_VERSION="89ef0f6e114ad943d94d153f1001c820f699a878"
PKG_SHA256="38c7ffe87c296130502f6761def6822d4836a325e78822b4fba94ec990baae17"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/skinsimple"
PKG_URL="https://gitlab.com/kamel5/skinsimple/-/archive/${PKG_VERSION}/skinsimple-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="skinsimple-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
