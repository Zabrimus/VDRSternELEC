# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-skinnopacity"
PKG_VERSION="d655b23e31362be537832e904aad272cb4aeed7f"
PKG_SHA256="faa6033568af25169692e95049a9927fd1ad9183f170dc72c1cc64dd66712ad5"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/SkinNopacity.git"
PKG_URL="https://gitlab.com/kamel5/SkinNopacity/-/archive/${PKG_VERSION}/SkinNopacity-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="SkinNopacity-${PKG_VERSION}"
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
