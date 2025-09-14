# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_gumbo"
PKG_VERSION="cc82e492a6d4604c4c5143851933ade388beeffe"
PKG_SHA256="07d82f050e96fc0cd4f77e3e8aa206e5bebc7c5e45b86bf55d040e3e614686e3"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/GerHobbelt/gumbo-parser"
PKG_URL="https://github.com/GerHobbelt/gumbo-parser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="gumbo-parser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gumbo - A pure-C HTML5 parser."
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
  cd $(get_build_dir _gumbo) && ./autogen.sh
}

make_target() {
  make CFLAGS="-DNO_GUMBO_DEBUG"
}
