# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-fritzbox"
PKG_VERSION="f481f76ae51ab3150b4784285715d4a3349bfdcd"
PKG_SHA256="db5f5e78e2b7dc18819aa9bcacdf0be8378e7b8b20599bcbc260fe3f0d89c4ef"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jowi24/vdr-fritz"
PKG_URL="https://github.com/jowi24/vdr-fritz/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-fritz-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libconvpp _libfritzpp _liblogpp _libnetpp boost vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _libconvpp _libfritzpp _liblogpp _libnetpp boost"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper) $(get_pkg_directory _libnetpp) $(get_pkg_directory _libconvpp) $(get_pkg_directory _liblogpp) $(get_pkg_directory _liblogpp) $(get_pkg_directory _libfritzpp)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig

   # reorganize build directory
   FRITZ_DIR=$(get_build_dir _vdr-plugin-fritzbox)
   rm -rf "${FRITZ_DIR}/libconv++" "${FRITZ_DIR}/libfritz++" "${FRITZ_DIR}/liblog++" "${FRITZ_DIR}/libnet++"
   ln -s $(get_build_dir _libnetpp) ${FRITZ_DIR}/libnet++
   ln -s $(get_build_dir _libconvpp) ${FRITZ_DIR}/libconv++
   ln -s $(get_build_dir _liblogpp) ${FRITZ_DIR}/liblog++
   ln -s $(get_build_dir _libfritzpp) ${FRITZ_DIR}/libfritz++

   # since boost 1.89 the stub library boost_system is not available anymore
   # the plugin Makefile needs to be patched
   if [ "${DISTRO}" = "LibreELEC" ] && [ "${OS_VERSION:0:2}" -ge "13" ]; then
   		sed -i -e "s/-lboost_system//" $(get_build_dir _vdr-plugin-fritzbox)/Makefile
   fi

   if [ "${DISTRO}" = "CoreELEC" ] && [ "${OS_VERSION:0:2}" -ge "22" ]; then
   		sed -i -e "s/-lboost_system//" $(get_build_dir _vdr-plugin-fritzbox)/Makefile
   fi
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox
  cp -r $(get_build_dir _vdr-plugin-fritzbox)/templates/on-call.sh ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox
  chmod +x ${INSTALL}/storage/.config/vdropt-sample/plugins/fritzbox/on-call.sh

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
