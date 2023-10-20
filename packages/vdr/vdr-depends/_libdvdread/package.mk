# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libdvdread"
PKG_VERSION="6.1.2"
PKG_SHA256="cc190f553758ced7571859e301f802cb4821f164d02bfacfd320c14a4e0da763"
PKG_LICENSE="GPL"
PKG_SITE="https://www.videolan.org/"
PKG_URL="https://download.videolan.org/pub/videolan/libdvdread/${PKG_VERSION}/libdvdread-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libdvdread is a library which provides a simple foundation for reading DVDs."
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           --sysconfdir=/usr/local/etc \
                           --with-gnu-ld \
                           --with-pic \
                           "

if [ "${KODI_DVDCSS_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" _libdvdcss"
  PKG_CONFIGURE_OPTS_TARGET+="--with-libdvdcss"
fi

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

#make_target() {
#  make CXXFLAGS="-fPIC"
#}
