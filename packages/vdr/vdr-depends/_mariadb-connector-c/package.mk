# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_mariadb-connector-c"
PKG_VERSION="3.4.6"
PKG_SHA256="27b57790896b7464e1b87fb29bad49e31ee36fdb6942e5c86284c6af9630be0e"
PKG_LICENSE="LGPL"
PKG_SITE="https://mariadb.org/"
PKG_URL="https://github.com/mariadb-corporation/mariadb-connector-c/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_LONGDESC="mariadb-connector: library to conntect to mariadb/mysql database server"
PKG_BUILD_FLAGS="-gold +speed"

PKG_CMAKE_OPTS_TARGET="-DINSTALL_LIBDIR=lib \
                       -DINSTALL_PLUGINDIR=lib \
                       -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
                       -DWITH_EXTERNAL_ZLIB=ON
					  "
