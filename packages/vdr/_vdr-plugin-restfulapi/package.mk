# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-restfulapi"
PKG_VERSION="be8a3a60af7e8926cb28c06e6b6d2adc2c2ed968"
PKG_SHA256="6a16cd7222e6a7ec315013ded94b0bb836bc7db19b370e45ba2cd36520fa9928"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/yavdr/vdr-plugin-restfulapi"
PKG_URL="https://github.com/yavdr/vdr-plugin-restfulapi/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
if [ "${DISTRO}" = "CoreELEC" ]; then
  WIRBELSCAN="_vdr-plugin-wirbelscan-ce"
else
  WIRBELSCAN="_vdr-plugin-wirbelscan"
fi
PKG_DEPENDS_TARGET="toolchain _vdr cxxtools vdr-helper ${WIRBELSCAN}"
PKG_DEPENDS_CONFIG="_vdr"
PKG_SOURCE_DIR="vdr-plugin-restfulapi-${PKG_VERSION}"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr ${WIRBELSCAN} vdr-helper)"
PKG_LONGDESC="Allows to access many internals of the VDR via a restful API."
PKG_MAKE_OPTS_TARGET="USE_LIBMAGICKPLUSPLUS=0"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

  if [ "${DISTRO}" = "CoreELEC" ]; then
    cp $(get_build_dir _vdr-plugin-wirbelscan-ce)/wirbelscan_services.h ${PKG_BUILD}/wirbelscan/
  else
    cp $(get_build_dir _vdr-plugin-wirbelscan)/wirbelscan_services.h ${PKG_BUILD}/wirbelscan/
  fi
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
