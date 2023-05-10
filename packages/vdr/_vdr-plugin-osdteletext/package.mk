# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-osdteletext"
PKG_VERSION="cae4629f84886015b0619af6fdb1084853b80f93"
PKG_SHA256="4e1a7a8c64fa68a4cd71aace4cdfa195ae4dedd7f2be7c34191982c752ed2207"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-osdteletext"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-osdteletext/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-osdteletext-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr cairo vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="Osd-Teletext displays the teletext directly on the OSD."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
