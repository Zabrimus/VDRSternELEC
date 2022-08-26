# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libdvdnav"
PKG_VERSION="6.1.1"
PKG_SHA256="c191a7475947d323ff7680cf92c0fb1be8237701885f37656c64d04e98d18d48"
PKG_LICENSE="GPL"
PKG_SITE="https://www.videolan.org/"
PKG_URL="https://download.videolan.org/pub/videolan/libdvdnav/${PKG_VERSION}/libdvdnav-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain _libdvdread"
PKG_LONGDESC="libdvdnav is a library that allows easy use of sophisticated DVD navigation features such as DVD menus, multiangle playback and even interactive DVD games."
PKG_TOOLCHAIN="auto"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           --sysconfdir=/usr/local/etc \
                           --with-gnu-ld \
                           --with-pic \
                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"

  DVDREAD_DIR=$(get_install_dir _libdvdread)
  export PKG_CONFIG_PATH=${DVDREAD_DIR}/usr/local/lib/pkgconfig:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPPFLAGS="-I${DVDREAD_DIR}/usr/local/include"

  echo "===> PKG: ${PKG_CONFIG_PATH}"
}

#make_target() {
#  make CXXFLAGS="-fPIC"
#}
