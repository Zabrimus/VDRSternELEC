# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvscraper"
PKG_VERSION="bf88fee29d1a77eae2328035c77d33cb28838bf1"
PKG_SHA256="ce5886e712a9f70ac9698916d386d438c077e8a43173c042bd4aba28099709f3"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-tvscraper"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-tvscraper/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-tvscraper-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr curl vdr-helper sqlite"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} tvscraper
}
