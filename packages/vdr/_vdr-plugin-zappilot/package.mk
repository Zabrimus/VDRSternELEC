# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-zappilot"
PKG_VERSION="c0f1aacd2e89249336552a5c1740840c749a5393"
PKG_SHA256="bf5e84e9beaa024188db484cefb2fa5ef7b23a7415d1c530053255494b6c4769"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-zappilot"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-zappilot/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-zappilot-${PKG_VERSION}"
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
