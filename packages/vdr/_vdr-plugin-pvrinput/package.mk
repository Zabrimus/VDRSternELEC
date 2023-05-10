# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-pvrinput"
PKG_VERSION="aef2954e20f55f585c892ba99d4d8b2f826e76bf"
PKG_SHA256="eda417c85c4054a49c9714dedbbfb5f20f9d0befa10533f1b5f96989b4f78412"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/yavdr/vdr-plugin-pvrinput"
PKG_URL="https://github.com/yavdr/vdr-plugin-pvrinput/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-pvrinput-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr systemd vdr-helper"
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
