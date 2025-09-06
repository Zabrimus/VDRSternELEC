# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-mp3"
PKG_VERSION="e48c8008e63bc8c5cb8d1edef78fdc5b11442eac"
PKG_SHA256="4fbc3cf7d099790e095346245eef6d4349fe1983277399833530454899b84783"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-mp3"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-mp3/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-mp3-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libmad libsndfile libvorbis _libid3tag vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _libmad libsndfile libvorbis _libid3tag"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="TODO"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/
  CXXFLAGS="$CXXFLAGS -fPIC"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} mp3
}
