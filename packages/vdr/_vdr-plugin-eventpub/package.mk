# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-eventpub"
PKG_VERSION="c4bca0baef368a36be1a981017d6396e374f8e82"
PKG_SHA256="d097186199489bfe27d45af9d8cef6da77d00efb6484e85025ab93761273209d"
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
