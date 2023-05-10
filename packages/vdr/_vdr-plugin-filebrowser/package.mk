# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-filebrowser"
PKG_VERSION="e09ba5519cf6db68190a2b176f0b6b442c870057"
PKG_SHA256="e6e1254f83db7080c7e1906465e40cf5539449badf3934cc861ef639b0525bc7"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-filebrowser"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-filebrowser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-filebrowser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
