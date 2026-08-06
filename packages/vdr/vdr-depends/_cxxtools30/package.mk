# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_cxxtools30"
PKG_VERSION="3.0"
PKG_SHA256="07b18037fb0983f6292f5c8d53e2369e9e7a9711df2c9ad50838aacbc8c62f7c"
PKG_LICENSE="GPL-2"
PKG_LICENSE="LGPL-2.1-or-later"
PKG_SITE="http://www.tntnet.org/cxxtools.html"
PKG_URL="http://ftp.rz.tu-braunschweig.de/pub/mirror/ubuntu-packages/pool/universe/c/cxxtools/cxxtools_${PKG_VERSION}.0.orig.tar.gz"
PKG_DEPENDS_HOST="toolchain:host openssl:host"
PKG_DEPENDS_TARGET="toolchain cxxtools:host openssl"
PKG_LONGDESC="Cxxtools is a collection of general-purpose C++ classes."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_HOST="--disable-demos --disable-unittest"
PKG_CONFIGURE_OPTS_TARGET="--disable-demos --disable-unittest"

pre_configure_host() {
	export CXXFLAGS="-std=c++11"
	export LDFLAGS="-lcrypto -lssl ${LDFLAGS}"
}

pre_configure_target() {
	export CXXFLAGS="-std=c++11"
	export LDFLAGS="-lcrypto -lssl ${LDFLAGS}"
}

post_makeinstall_host() {
  rm -rf ${TOOLCHAIN}/bin/cxxtools-config
}

post_makeinstall_target() {
  cp cxxtools-config ${TOOLCHAIN}/bin
  sed -e "s:\(['= ]\)/usr:\\1${PKG_ORIG_SYSROOT_PREFIX}/usr:g" -i ${TOOLCHAIN}/bin/cxxtools-config
  chmod +x ${TOOLCHAIN}/bin/cxxtools-config

  rm -rf ${INSTALL}/usr/bin
}

