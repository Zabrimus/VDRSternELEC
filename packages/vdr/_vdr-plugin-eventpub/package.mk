# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-eventpub"
PKG_VERSION="cdd95380fa188ff575e76b391ba60ddbbbb4bcf6"
PKG_SHA256="741952f57eff42dd103e63f5549524e7a7995a7665826240febf9323eee335a4"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/vdr-plugin-eventpub"
PKG_URL="https://github.com/Zabrimus/vdr-plugin-eventpub/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-eventpub-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper _nats_c"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR plugin which sends events/messages via NATS "
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

make_target() {
	make -j USE_LOCAL_NATS=0
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
