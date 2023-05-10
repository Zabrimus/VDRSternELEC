# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-tvguide"
PKG_VERSION="573a844f7d58b72ca632094ae4245cd05389e06d"
PKG_SHA256="185875d22340de3fd40bcdf02080880f660519e372886920b258ea8e61e93112"
PKG_LICENSE="GPL2"
PKG_SITE="https://gitlab.com/kamel5/tvguide.git"
PKG_URL="https://gitlab.com/kamel5/tvguide/-/archive/${PKG_VERSION}/tvguide-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="tvguide-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _graphicsmagick"
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
