# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-vompserver"
PKG_VERSION="6544d026851dc6d6df7927a8bbb8529410b7896c"
PKG_SHA256="37f0369a6d6f784ee4bc98bfd45e4f990cfe057efefdfbcc93636d950114b9eb"
PKG_LICENSE="GPL"
PKG_SITE="https://www.loggytronic.com/vomp.php"
PKG_URL="https://git.vomp.tv/vompserver.git"
PKG_SOURCE_DIR="_vdr-plugin-vompserver-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
