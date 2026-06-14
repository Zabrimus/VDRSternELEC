# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-pvrinput"
PKG_VERSION="f01e2883c88213109dc9c25b8144e92a7fb838ec"
PKG_SHA256="233e364b71b39f289c3d5968c93c477fc294acb6897118ca7b2e7794e640796e"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/yavdr/vdr-plugin-pvrinput"
PKG_URL="https://github.com/yavdr/vdr-plugin-pvrinput/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-pvrinput-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr systemd vdr-helper"
PKG_DEPENDS_CONFIG="_vdr systemd"
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
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
