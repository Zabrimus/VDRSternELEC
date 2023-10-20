# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-recsearch"
PKG_VERSION="071ca720d59638dccd3723292c5970ee8352ad30"
PKG_SHA256="cd53c7335afd5e11375ead4768af16a78bcc9c196961793dfffc1fed531c5ef9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/flensrocker/vdr-plugin-recsearch"
PKG_URL="https://github.com/flensrocker/vdr-plugin-recsearch/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-recsearch-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
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
