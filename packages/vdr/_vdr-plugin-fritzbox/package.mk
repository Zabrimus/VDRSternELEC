# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-fritzbox"
PKG_VERSION="368a393a3e56f49d5f8b3c4411acf511e1796690"
PKG_SHA256="164c622ec32a4dbe2e448da94ad03ffb252f05602a4c1b31239ddf2082b39a4c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jowi24/vdr-fritz"
PKG_URL="https://github.com/jowi24/vdr-fritz/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-fritz-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libconvpp _libfritzpp _liblogpp _libnetpp boost vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

   # reorganize build directory
   FRITZ_DIR=$(get_build_dir _vdr-plugin-fritzbox)
   rm -rf "${FRITZ_DIR}/libconv++" "${FRITZ_DIR}/libfritz++" "${FRITZ_DIR}/liblog++" "${FRITZ_DIR}/libnet++"
   ln -s $(get_build_dir _libnetpp) ${FRITZ_DIR}/libnet++
   ln -s $(get_build_dir _libconvpp) ${FRITZ_DIR}/libconv++
   ln -s $(get_build_dir _liblogpp) ${FRITZ_DIR}/liblog++
   ln -s $(get_build_dir _libfritzpp) ${FRITZ_DIR}/libfritz++
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox
  cp -r $(get_build_dir _vdr-plugin-fritzbox)/templates/on-call.sh ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox
  chmod +x ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox/on-call.sh

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
