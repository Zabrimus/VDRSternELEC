# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_a52dec"
PKG_VERSION="0.7.4"
PKG_SHA256="a21d724ab3b3933330194353687df82c475b5dfb997513eef4c25de6c865ec33"
PKG_LICENSE="GPL"
PKG_SITE="https://liba52.sourceforge.io"
PKG_URL="https://liba52.sourceforge.io/files/a52dec-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _libdvdread"
PKG_LONGDESC="liba52 - a free ATSC A/52 stream decoder"
PKG_TOOLCHAIN="auto"

PKG_CONFIGURE_OPTS_TARGET="--prefix=${VDR_PREFIX} \
						   --bindir=${VDR_PREFIX}/bin \
                           --libdir=${VDR_PREFIX}/lib \
                           --libexecdir=${VDR_PREFIX}/bin \
                           --sbindir=${VDR_PREFIX}/sbin \
                           --sysconfdir=${VDR_PREFIX}/etc \
                           --disable-oss \
						   --disable-solaris-audio \
						   --disable-al-audio \
                           --disable-win \
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
}

make_target() {
  make CFLAGS="-fPIC"
}
