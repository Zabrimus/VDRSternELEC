# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvscraper"
PKG_VERSION="c8bc4fc51e5c52f3f29937981fe09ae819cc6988"
PKG_SHA256="cbb40a79f5644e5fe3fd7da6d819c97705d05f379f8fcc033430184bdca8cad7"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-tvscraper"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-tvscraper/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-tvscraper-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr curl vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} tvscraper
}
