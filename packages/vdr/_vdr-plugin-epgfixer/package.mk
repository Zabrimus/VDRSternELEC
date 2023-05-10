# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epgfixer"
PKG_VERSION="354f28b0112ba27f08f6509243b410899f74b6ed"
PKG_SHA256="15bd73116f3bda9afc274bee97eff829b98f38b13043be32d7bb7f81af294715"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-epgfixer"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-epgfixer/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _vdr pcre vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="Plugin for modifying EPG data using regular expressions."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
