# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_grpc"
PKG_VERSION="8871dab19b4ab5389e28474d25cfeea61283265c"
PKG_LICENSE="Apache Licencse"
PKG_SITE="https://github.com/grpc/grpc"
PKG_URL="https://github.com/grpc/grpc.git"
PKG_GIT_CLONE_BRANCH="v1.54.x"
PKG_GIT_CLONE_DEPTH="1"
PKG_GIT_SUBMODULE_DEPTH="1"
PKG_DEPENDS_TARGET="toolchain _grpc:host"
PKG_DEPENDS_HOST="toolchain:host"
PKG_LONGDESC="TEST"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release \
                     -DgRPC_INSTALL=OFF \
                     -DgRPC_BUILD_TESTS=OFF \
                     -DBUILD_SHARED_LIBS=OFF"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
					   -DgRPC_INSTALL=ON \
                       -DgRPC_BUILD_TESTS=OFF \
                       -DCMAKE_INSTALL_PREFIX=/usr/local \
                       -DBUILD_SHARED_LIBS=OFF"

make_host() {
	ninja protoc
	cp `pwd`/third_party/protobuf/protoc ${TOOLCHAIN}/bin

    ninja grpc_cpp_plugin
  	cp `pwd`/grpc_cpp_plugin ${TOOLCHAIN}/bin
}

post_makeinstall_target() {
	cp ${PKG_DIR}/config/re2.pc $(get_install_dir _grpc)/usr/local/lib/pkgconfig

	# TEST if everything works
	# export PKG_CONFIG_PATH=$(get_install_dir _grpc)/usr/local/lib/pkgconfig

    # CF=$(pkg-config --cflags grpc)
    # echo "====> cflags = ${CF}"

    # LI=$(pkg-config --libs grpc)
    # echo "====> libs = ${LI}"
}
