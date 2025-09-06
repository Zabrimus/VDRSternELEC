# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-extrecmenung"
PKG_VERSION="2c08ab3f89735968794cd723a11890accafb149d"
PKG_SHA256="80530339c5ef8b4384fb699ab333f2bf97f9e61359054751cba03c658307882c"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/extrecmenung.git"
PKG_URL="https://gitlab.com/kamel5/extrecmenung/-/archive/${PKG_VERSION}/extrecmenung-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="extrecmenung-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
