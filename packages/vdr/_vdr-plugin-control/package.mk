# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-control"
PKG_VERSION="c2d0fde071e84486ac81f359b3345f08ae35922a"
PKG_SHA256="44a01a259b509e849f76016fcb29c8aff7302e4c09c46dd3b40aefb8a453b6db"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control"
PKG_URL="https://github.com/wirbel-at-vdr-portal/vdr-plugin-control/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-control-${PKG_VERSION}"
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
