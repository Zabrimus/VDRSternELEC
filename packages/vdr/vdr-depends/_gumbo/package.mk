# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_gumbo"
PKG_VERSION="666fbbed13535931f161741849631242bb6f5cbe"
PKG_SHA256="9b07de558fdd37146c784414dbda7c5982db9b494eaea6324128e2ab6be57485"
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
