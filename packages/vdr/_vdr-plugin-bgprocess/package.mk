# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-bgprocess"
PKG_VERSION="140b764b60a930b9098e1e17f45aee45983425da"
PKG_SHA256="ef36195bb5e819ca32a0df9abac2f5cc85da6d4ccc95ed98d19762f30d8c9eb5"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-bgprocess"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-bgprocess/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-bgprocess-${PKG_VERSION}"
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
