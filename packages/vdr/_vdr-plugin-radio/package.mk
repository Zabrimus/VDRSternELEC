# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-radio"
PKG_VERSION="f0c89c2c2285743bcc62ecca473b270359af8775"
PKG_SHA256="e58c236358d0adfd5f14a844292019bd820f7ddf41ee690410b70916e52acfed"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-radio"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-radio/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-radio-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/radio
  cp -r $(get_build_dir _vdr-plugin-radio)/config/scripts ${INSTALL}/storage/.config/vdropt-sample/plugins/radio
  cp -r $(get_build_dir _vdr-plugin-radio)/config/mpegstill ${INSTALL}/storage/.config/vdropt-sample/plugins/radio

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
