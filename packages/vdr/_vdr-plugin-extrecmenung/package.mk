# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-extrecmenung"
PKG_VERSION="c4305b4cae62574df7d92273ee6ea5d7d3ca9a06"
PKG_SHA256="32463a9217b3d0d932a023e7830958275508241d478c6ce8295be912527755fa"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/extrecmenung.git"
PKG_URL="https://gitlab.com/kamel5/extrecmenung/-/archive/${PKG_VERSION}/extrecmenung-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="extrecmenung-${PKG_VERSION}"
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
