# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_mariadb-connector-c"
PKG_VERSION="3.3.10"
PKG_SHA256="0a79088af2fbde4dbe6655dbc51bbb272b606c0d9116745697e08879e70198a7"
PKG_LICENSE="LGPL"
PKG_SITE="https://mariadb.org/"
PKG_URL="https://github.com/mariadb-corporation/mariadb-connector-c/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl curl"
PKG_LONGDESC="mariadb-connector: library to conntect to mariadb/mysql database server"
PKG_BUILD_FLAGS="-gold +speed"

PKG_CMAKE_OPTS_TARGET="-DINSTALL_LIBDIR=lib \
                       -DINSTALL_PLUGINDIR=lib \
                       -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
                       -DWITH_EXTERNAL_ZLIB=ON \
                       -DWITH_CURL=ON
					  "
