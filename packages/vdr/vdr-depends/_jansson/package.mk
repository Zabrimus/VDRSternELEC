# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_jansson"
PKG_VERSION="2.14.1"
PKG_SHA256="6bd82d3043dadbcd58daaf903d974891128d22aab7dada5d399cb39094af49ce"
PKG_LICENSE="MIT"
PKG_SITE="www.digip.org/jansson/"
PKG_URL="https://github.com/akheron/jansson/releases/download/v${PKG_VERSION}/jansson-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Jansson is a C library for encoding, decoding and manipulating JSON data."
PKG_BUILD_FLAGS="+speed"
PKG_CMAKE_OPTS_TARGET="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
