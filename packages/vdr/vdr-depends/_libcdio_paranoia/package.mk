# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libcdio_paranoia"
PKG_VERSION="10.2+2.0.1"
PKG_SHA256="7a4e257c85f3f84129cca55cd097c397364c7a6f79b9701bbc593b13bd59eb95"
PKG_LICENSE="GPL3"
PKG_SITE="https://www.gnu.org/software/libcdio/"
PKG_URL="https://github.com/rocky/libcdio-paranoia/archive/release-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="libcdio-paranoia-release-10.2-2.0.1"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"

#PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
#						   --bindir=/usr/local/bin \
#                           --libdir=/usr/local/lib \
#                           --libexecdir=/usr/local/bin \
#                           --sbindir=/usr/local/sbin \
#                           --sysconfdir=/usr/local/etc \
#                           --disable-cpp-progs \
#                           --disable-example-progs \
#                           --with-gnu-ld \
#                           --with-pic \
#                           CC=${CC} \
#                           CXX=${CXX} \
#                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"

  ./autogen.sh --prefix=/usr/local --disable-cpp-progs --disable-example-progs
}

configure_target() {
	# ./configure --prefix=/usr/local --disable-cpp-progs --disable-static --disable-example-progs --host="XXX" --build="XXX"
	echo
}