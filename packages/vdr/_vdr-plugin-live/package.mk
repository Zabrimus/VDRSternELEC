# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-live"
PKG_VERSION="62a875e68ba80fbe99a05a0ecff744b2199e089b"
PKG_SHA256="a3a4c97ed086b81609cd7fc363e141d2fbcf8c3e68ee40540122f355409c786b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/MarkusEh/vdr-plugin-live"
PKG_URL="https://github.com/MarkusEh/vdr-plugin-live/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr tntnet pcre2 libiconv cxxtools vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr vdr-helper)"
PKG_SOURCE_DIR="vdr-plugin-live-${PKG_VERSION}"
PKG_LONGDESC="Allows a comfortable operation of VDR and some of its plugins trough a web interface."
PKG_BUILD_FLAGS="+pic -parallel +speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
}

post_makeinstall_target() {
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} live
}
