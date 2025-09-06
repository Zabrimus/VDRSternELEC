# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-screenshot"
PKG_VERSION="ccb535801df1ae2d272c3ebed1927a8edb85915b"
PKG_SHA256="8f994a5c606ff10f0e34e98aca18a91290a4ecf98ba6db8f6b24b0ad84ffc265"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jowi24/vdr-screenshot"
PKG_URL="https://github.com/jowi24/vdr-screenshot/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-screenshot-${PKG_VERSION}"
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
