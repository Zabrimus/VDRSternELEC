# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-easyvdr"
PKG_VERSION="2021.01.24.1"
PKG_SHA256="384e0f7ff47ef4158e70b6cb71a7639679c1f6256c234dec4006e4c9a880650a"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gen2vdr.de/wirbel/easyvdr/index2.html"
PKG_URL="https://www.gen2vdr.de/wirbel/easyvdr/vdr-easyvdr-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="easyvdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr Python3 vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr Python3 _mariadb-connector-c vdr-helper)"
PKG_LONGDESC="This plugin is used to retrieve EPG data into the VDR. The EPG data was loaded from a mariadb database."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
