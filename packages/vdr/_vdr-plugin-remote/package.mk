# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-remote"
PKG_VERSION="0.7.0-6"
PKG_SHA256="e7ae97f8ff853a98f90514b20f5d0a06cbef0790c45e9c304ba07cabe09f5ae4"
PKG_LICENSE="GPL"
PKG_SITE="http://www.escape-edv.de/endriss/vdr/"
PKG_URL="https://salsa.debian.org/vdr-team/vdr-plugin-remote/-/archive/debian/${PKG_VERSION}/vdr-plugin-remote-debian-${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-remote-debian-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="remote - Remote Control plugin for the Video Disk Recorder (VDR)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
