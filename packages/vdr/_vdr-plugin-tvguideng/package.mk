# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvguideng"
PKG_VERSION="0f47b80c36462d23322d29dbdfd7fe9d5640aae4"
PKG_SHA256="072f10fa30aa7384eccd385d0e17bf698c658ea1e72a027ea79dd72be27f2503"
PKG_LICENSE="GPL2"
PKG_SITE="https://gitlab.com/kamel5/tvguideng.git"
PKG_URL="https://gitlab.com/kamel5/tvguideng/-/archive/${PKG_VERSION}/tvguideng-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="tvguideng-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-skindesigner vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _vdr-plugin-skindesigner"
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
