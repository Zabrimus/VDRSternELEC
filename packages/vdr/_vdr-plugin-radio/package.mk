# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-radio"
PKG_VERSION="468280ff7252f9504e5b3d63fcf5d277b5627541"
PKG_SHA256="d7f49bbc5269dbd9059149ad1df61128d9c4600df28b76be4d1d35a236ad6888"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-radio"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-radio/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-radio-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/radio
  cp -r $(get_build_dir _vdr-plugin-radio)/config/scripts ${INSTALL}/storage/.config/vdropt-sample/plugins/radio
  cp -r $(get_build_dir _vdr-plugin-radio)/config/mpegstill ${INSTALL}/storage/.config/vdropt-sample/plugins/radio

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
