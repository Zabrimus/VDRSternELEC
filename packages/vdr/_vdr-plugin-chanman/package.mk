# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-chanman"
PKG_VERSION="193e4220e2607b403b0e04589b608289f9ae73e7"
PKG_SHA256="8f6ff8fa9cf91fd7c7e7f2484200b9644852bde25da1d59373b546abccc0bc7a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-chanman"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-chanman/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-chanman-${PKG_VERSION}"
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
