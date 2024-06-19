# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_graphicsmagick"
PKG_VERSION="1.3.43"
PKG_SHA256="2b88580732cd7e409d9e22c6116238bef4ae06fcda11451bf33d259f9cbf399f"
PKG_LICENSE="GraphiksMagick License"
PKG_SITE="http://www.graphicsmagick.org/index.html"
PKG_URL="https://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/${PKG_VERSION}/GraphicsMagick-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libXext"
PKG_LONGDESC="Use GraphiksMagick to create, edit, compose, or convert digital images."
PKG_SOURCE_DIR="GraphicsMagick-${PKG_VERSION}"
# PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--disable-openmp \
                           --prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                            --sysconfdir=/usr/local/etc \
                           "
pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  # drop all unneeded
  rm -rf ${INSTALL}/usr/local/{bin,share,etc}
}


