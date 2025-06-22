# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-cinebars"
PKG_VERSION="43a36505c97a16728363d32e9edb17dfe1471a03"
PKG_SHA256="c67cf3e07b5148ae373054b9232d30c6d403f776589a1ba661cf77561168da47"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-cinebars"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-cinebars/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-cinebars-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="Overlays cinema-bars over the live picture"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
