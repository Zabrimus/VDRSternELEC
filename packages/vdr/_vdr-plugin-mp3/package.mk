# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-mp3"
PKG_VERSION="dd4ba2a0f56faae9f033876420886ec6875f0aad"
PKG_SHA256="5cef6b757ca5f2ba774f41f43b1345cdbf6c9875c78fb1ef2ffa226e9829b70e"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vdr-projects/vdr-plugin-mp3"
PKG_URL="https://github.com/vdr-projects/vdr-plugin-mp3/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-mp3-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libmad libsndfile libvorbis _libid3tag"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="TODO"
PKG_MAKE_OPTS_TARGET="VDRDIR=$(get_build_dir _vdr)"
PKG_MAKEINSTALL_OPTS_TARGET="VDRDIR=$(get_build_dir _vdr)"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  CXXFLAGS="$CXXFLAGS -fPIC"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/mp3-sample-config.zip" storage
}
