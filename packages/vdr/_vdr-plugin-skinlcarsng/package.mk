# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinlcarsng"
PKG_VERSION="60d03dc2ab29615f2df159b8a06eaf6b63bbe169"
PKG_SHA256="6f77a64934038869e1cdc89e8d48f06302b1e36c129c0ffdb01089bf74873754"
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
