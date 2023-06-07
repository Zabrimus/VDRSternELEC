# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-markad"
PKG_VERSION="dd4e5f874f6e9832977b9d9f4a677cdc3b8de1dc"
PKG_SHA256="67c8e9fe8d938e7fe059c01d1905b4e90eccf0d278bd859e2d0b649c2e44d14e"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/kfb77/vdr-plugin-markad"
PKG_URL="https://github.com/kfb77/vdr-plugin-markad/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-markad-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr ffmpeg vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN} markad
}
