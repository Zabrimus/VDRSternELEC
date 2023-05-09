# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-suspendoutput"
PKG_VERSION="2.1.0"
PKG_SHA256="3109de8b18431613b8ebd5d9a2dd8b6b730a8efd321beb2b13508ae1825c80ed"
PKG_LICENSE="GPL"
PKG_SITE="http://phivdr.dyndns.org/vdr/vdr-suspendoutput"
PKG_URL="http://phivdr.dyndns.org/vdr/vdr-suspendoutput/vdr-suspendoutput-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="suspendoutput-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="Suspends VDR output"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
