# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-mp3"
PKG_VERSION="ec219b3ece32686f72d8b1ad6b8de3b3a9dd3759"
PKG_SHA256="81deca2b2603ebc49cd739c59f475b4a57fad7997cf5a78f6e56ab2a96f4cead"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-mp3"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-mp3/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-mp3-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libmad libsndfile libvorbis _libid3tag vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_LONGDESC="TODO"
PKG_MAKE_OPTS_TARGET="VDRDIR=$(get_build_dir _vdr)"
PKG_MAKEINSTALL_OPTS_TARGET="VDRDIR=$(get_build_dir _vdr)"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  CXXFLAGS="$CXXFLAGS -fPIC"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} mp3
}
