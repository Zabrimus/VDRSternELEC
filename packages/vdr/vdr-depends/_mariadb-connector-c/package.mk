# SPDX-License-Identifier: GPL-2.0

PKG_NAME="_mariadb-connector-c"
PKG_VERSION="3.2.6"
PKG_SHA256="d9aee070e1d954074a70eff1cfd2d6c6bc5d190dc00075975a55d4f3e1ac20c5"
PKG_LICENSE="LGPL"
PKG_SITE="https://mariadb.org/"
PKG_URL="https://github.com/mariadb-corporation/mariadb-connector-c/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_LONGDESC="mariadb-connector: library to conntect to mariadb/mysql database server"
PKG_BUILD_FLAGS="-gold"

PKG_CMAKE_OPTS_TARGET="-DINSTALL_LIBDIR=lib \
                       -DINSTALL_PLUGINDIR=lib \
					  "
