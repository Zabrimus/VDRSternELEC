# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhdvaapi"
PKG_VERSION="8629946041b5b901fd16941fd5f9110c333a2512"
PKG_SHA256="934c74c148215897ad1401f3ba21da949b68b74ffa5b9054c77974fa3dafea8c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jojo61/vdr-plugin-softhdcuvid"
PKG_URL="https://github.com/jojo61/vdr-plugin-softhdcuvid/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-softhdcuvid-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libplacebo vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="VDR Output Device (softhdvaapi)"
PKG_MAKE_OPTS_TARGET="NVIDIA=$(get_install_dir nvidia)"
PKG_MAKEINSTALL_OPTS_TARGET="NVIDIA=$(get_install_dir nvidia)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

  # build configuration
  export VAAPI=1
  export CUVID=0
  export DRM=0
  export LIBPLACEBO=0
  export LIBPLACEBO_GL=1
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/softhdvaapi

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
