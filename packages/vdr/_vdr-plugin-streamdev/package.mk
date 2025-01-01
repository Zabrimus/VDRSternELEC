# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-streamdev"
PKG_VERSION="90939c1f1119fb926f08c646c990074a42893c4b"
PKG_SHA256="5f810c10f40bb6735ca26983f4cd2b589fe363f7dbe8036c30fdc496070f85c9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-streamdev"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-streamdev/archive/${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain _vdr openssl vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="This PlugIn is a VDR implementation of Video Transfer and a basic HTTP Streaming Protocol."
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  APIVERSION=$(pkg-config --variable=apiversion vdr)

  cp ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client2.so.${APIVERSION}
  cp ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client3.so.${APIVERSION}
  cp ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-streamdev-client4.so.${APIVERSION}

  # copy configuration files
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/streamdev-server
  cp $(get_build_dir _vdr-plugin-streamdev)/streamdev-server/* ${INSTALL}/storage/.config/vdropt-sample/plugins/streamdev-server

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
