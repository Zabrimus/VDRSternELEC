# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-devstatus"
PKG_VERSION="ea22649f47aaaa35dcaeaf8208ef48ea8f3068c7"
PKG_SHA256="b025aea7f42e2fa5cadbea1324ee7e93f7fa8b177d4705b9e1b08233cd2b87e5"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/devstatus.git"
PKG_URL="https://gitlab.com/kamel5/devstatus/-/archive/${PKG_VERSION}/devstatus-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="devstatus-${PKG_VERSION}"
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
