# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_tntnet30"
PKG_VERSION="3.0"
PKG_SHA256="718e5519b0a403f7f766358bf66a85c008119c48189d1c2b7651fd0af9018e27"
PKG_LICENSE="GPL-2"
PKG_LICENSE="LGPL-2.1-or-later"
PKG_SITE="https://github.com/maekitalo/tntnet"
PKG_URL="http://slackware.uk/sbosrcarch/by-name/network/tntnet/tntnet-3.0.tar.gz"
PKG_DEPENDS_HOST="_cxxtools30:host zlib:host"
PKG_DEPENDS_TARGET="toolchain _tntnet30:host libtool _cxxtools30 zlib"
PKG_LONGDESC="A web application server for C++."

PKG_CONFIGURE_OPTS_HOST="--disable-unittest \
                         --disable-server \
                         --enable-sdk \
                         --disable-demos"

PKG_CONFIGURE_OPTS_TARGET="--disable-unittest \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           --disable-server \
                           --disable-sdk \
                           --disable-demos"
                           #--disable-shared \
                           #--enable-static"

pre_configure_host() {
	export CXXFLAGS="-std=c++11"
	export LDFLAGS="-lcrypto -lssl ${LDFLAGS}"
}

pre_configure_target() {
	export CXXFLAGS="-std=c++11"
	export LDFLAGS="-lcrypto -lssl ${LDFLAGS}"
}

post_configure_target() {
  libtool_remove_rpath libtool
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
  rm -rf ${INSTALL}/usr/share
}
