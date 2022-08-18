# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_graphicsmagick"
PKG_VERSION="1.3.38"
PKG_SHA256="35b8661f508337314e46aebcbdca6875cc6033a1cf3edff29aa5e14ef8d2d4e1"
PKG_LICENSE="GraphiksMagick License"
PKG_SITE="http://www.graphicsmagick.org/index.html"
PKG_URL="https://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/${PKG_VERSION}/GraphicsMagick-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Use GraphiksMagick to create, edit, compose, or convert digital images."
PKG_SOURCE_DIR="GraphicsMagick-${PKG_VERSION}"
# PKG_TOOLCHAIN="manual"

PKG_CONFIGURE_OPTS_TARGET="--disable-openmp \
                           --prefix=${VDR_PREFIX} \
						   --bindir=${VDR_PREFIX}/bin \
                           --libdir=${VDR_PREFIX}/lib \
                           --libexecdir=${VDR_PREFIX}/bin \
                           --sbindir=${VDR_PREFIX}/sbin \
                            --sysconfdir=${VDR_PREFIX}/etc \
                           "
pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}

post_makeinstall_target() {
  # drop all unneeded
  rm -rf ${INSTALL}/${VDR_PREFIX}/{bin,share,etc}
}


