# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_nats_c"
PKG_VERSION="3.11.0"
PKG_SHA256="9ee45cd502a49dbd29bed491286a4926e5e53f14a8aacad413c0cf4a057abee0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/nats-io/nats.c"
PKG_URL="https://github.com/nats-io/nats.c/archive/refs/tags/v3.11.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain libsodium openssl"
PKG_LONGDESC="A C client for NATS"
PKG_BUILD_FLAGS="+speed"

PKG_CMAKE_OPTS_TARGET="-DNATS_BUILD_WITH_TLS=ON \
					   -DNATS_BUILD_USE_SODIUM=ON \
					   -DCMAKE_INSTALL_PREFIX=/usr \
					   -DNATS_BUILD_LIB_STATIC=OFF\
					   -DBUILD_TESTING=OFF \
                      "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
