# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinlcarsng"
PKG_VERSION="95a43347622fa68a43e66b8ba0f25d5f78617d56"
PKG_SHA256="ed866708fed2315a7e727a50bcfc2a10f3f6ff2f0c1e55e155c8026396e049d2"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/skinlcarsng.git"
PKG_URL="https://gitlab.com/kamel5/skinlcarsng/-/archive/${PKG_VERSION}/skinlcarsng-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="skinlcarsng-${PKG_VERSION}"
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
