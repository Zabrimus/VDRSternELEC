# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-remoteosd"
PKG_VERSION="0cf364de2e9063dab6c42e9fbc9982a51458e274"
PKG_SHA256="17c1f0651b7136ccbbea9f81afb3b7f9b06db2f37f27e6ff98557a6ed533ff1d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-remoteosd"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-remoteosd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-remoteosd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _vdr-plugin-svdrpservice vdr-helper"
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
