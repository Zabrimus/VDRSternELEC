# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libcdio"
PKG_VERSION="2.1.0"
PKG_SHA256="35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
PKG_LICENSE="GPL2"
PKG_SITE="http://libcddb.sourceforge.net/index.html"
PKG_URL="http://git.savannah.gnu.org/cgit/libcdio.git/snapshot/libcdio-release-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="libcdio-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--prefix=${VDR_PREFIX} \
						   --bindir=${VDR_PREFIX}/bin \
                           --libdir=${VDR_PREFIX}/lib \
                           --libexecdir=${VDR_PREFIX}/bin \
                           --sbindir=${VDR_PREFIX}/sbin \
                           --sysconfdir=${VDR_PREFIX}/etc \
                           --with-gnu-ld \
                           --with-pic \
                           "
pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"

  ./autogen.sh
}
