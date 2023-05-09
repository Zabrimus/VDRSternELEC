# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-cecremote"
PKG_VERSION="1.5.0"
PKG_SHA256="406f3cda3f26483d49be015f9ff5ae2430898f7db38bc1aec90eff06fe3c5cd1"
PKG_LICENSE="GPL"
PKG_SITE="https://www.uli-eckhardt.de/vdr/cec.de.shtml"
PKG_URL="https://www.uli-eckhardt.de/vdr/download/vdr-cecremote-${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="cecremote-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr libcec pugixml vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  BUILD_DIR=$(get_build_dir _vdr-plugin-cecremote)
  PLGRES_DIR="${INSTALL}/storage/.config/vdropt-sample/plugins/cecremote"
  mkdir -p ${PLGRES_DIR}
  cp ${BUILD_DIR}/contrib/* ${PLGRES_DIR}

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
