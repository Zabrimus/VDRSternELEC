# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-permashift"
PKG_VERSION="afec850e8a5ed1ad215714f26bd94ad1dd0a028a"
PKG_SHA256="9b79ad2952ca75758b760dabba4833de80af5ed5ac1d4246802a5f05564c7dc1"
PKG_LICENSE="GPL"
PKG_SITE="https://ein-eike.de/vdr-plugin-permashift-english/"
PKG_URL="https://github.com/eikesauer/Permashift/archive/afec850e8a5ed1ad215714f26bd94ad1dd0a028a.zip"
PKG_SOURCE_DIR="Permashift-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="Permanent timeshift plugin for Video Disc Recorder (VDR)"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
