# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-markad"
PKG_VERSION="7905f1a2433922a4f27a96c35d8ba16b55487c4f"
PKG_SHA256="4fcb919d0512d79610bdd7b4576fcd68e5fe73c875ae3eaf9bfca75e7b2b78f5"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/kfb77/vdr-plugin-markad"
PKG_URL="https://github.com/kfb77/vdr-plugin-markad/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-markad-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr ffmpeg vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN} markad
}
