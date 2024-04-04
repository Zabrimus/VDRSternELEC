# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-extrecmenung"
PKG_VERSION="0519f1a2701b14d6263c7332e29c267a8ea5e4f7"
PKG_SHA256="ee21d668d6d016e67fd1d9e3180e39f92e5a990af53ad839bc679924979a04d6"
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
