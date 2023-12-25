# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvscraper"
PKG_VERSION="c293bbdb5e6ff740809efbd621d475eeb5adc01f"
PKG_SHA256="e219a9a6b93cd9f8f83b1f9a791dc1f393320c2823e11d8e3ba2b1d2579b9b33"
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
