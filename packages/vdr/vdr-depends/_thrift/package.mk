# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_thrift"
PKG_VERSION="0.24.0"
PKG_SHA256="fd77a4e69892af7c6df430f660e17f881e30ee95c341e02e49595c1ff03a1eef"
PKG_LICENSE="Apache License 2.0"
PKG_SITE="https://github.com/apache/thrift"
PKG_URL="https://github.com/apache/thrift/archive/refs/tags/v${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain boost"
PKG_LONGDESC="Apache Thrift"
PKG_SOURCE_DIR="thrift-${PKG_VERSION}"
PKG_TOOLCHAIN="cmake"
PKG_BUILD_FLAGS="+speed"

PKG_CMAKE_OPTS_TARGET="-DWITH_AS3=OFF \
                       -DWITH_QT5=OFF \
                       -DBUILD_JAVA=OFF \
                       -DBUILD_JAVASCRIPT=OFF \
                       -DWITH_NODEJS=OFF \
                       -DBUILD_PYTHON=OFF \
                       -DBUILD_TESTING=OFF \
                       -DWITH_C_GLIB=OFF \
                       -DWITH_OPENSSL=OFF \
                       -DBUILD_SHARED_LIBS=OFF \
                       -DBUILD_COMPILER=OFF \
                       -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
                       -DCMAKE_CXX_STANDARD=11"
