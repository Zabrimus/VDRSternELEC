# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_a52dec"
PKG_VERSION="0.8.0"
PKG_SHA256="470d084074d15416a0f0f300b85b61ddcc1ce105ad14a2aac670a1767ecba8de"
PKG_LICENSE="GPL"
PKG_SITE="https://git.adelielinux.org/community/a52dec"
PKG_URL="https://git.adelielinux.org/community/a52dec/-/archive/v${PKG_VERSION}/a52dec-v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _libdvdread"
PKG_LONGDESC="liba52 - a free ATSC A/52 stream decoder"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           --sysconfdir=/usr/local/etc \
                           --disable-oss \
						   --disable-solaris-audio \
						   --disable-al-audio \
                           --disable-win \
                           --with-gnu-ld \
                           --with-pic \
                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  cd $(get_build_dir _a52dec) && ./bootstrap
}

make_target() {
  make CFLAGS="-fPIC"
}
