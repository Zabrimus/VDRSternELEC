# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-extrecmenung"
PKG_VERSION="1bf863cff424c2f33c54b691492f57b260f9a7a3"
PKG_SHA256="0493b0b0552028947cdfcd3b44d24d4329e7d1c62cbd1a431e8acaac7709c3e1"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/kamel5/extrecmenung.git"
PKG_URL="https://gitlab.com/kamel5/extrecmenung/-/archive/${PKG_VERSION}/extrecmenung-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_SOURCE_DIR="extrecmenung-${PKG_VERSION}"
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
