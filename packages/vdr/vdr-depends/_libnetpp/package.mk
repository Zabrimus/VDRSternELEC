# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libnetpp"
PKG_VERSION="9b5400cbed4d84dcf539791774041a3bd9c5263d"
PKG_SHA256="ebeb8beeeb8d4a21344669b5946228a3765c31269c8d4406b9b0964484284051"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/jowi24/libnetpp"
PKG_URL="https://github.com/jowi24/libnetpp/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="libnetpp-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _liblogpp boost"
PKG_DEPENDS_UNPACK="_liblogpp _libconvpp"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  LOGPP=$(get_build_dir _liblogpp)
  CONVPP=$(get_build_dir _libconvpp)

  cd ..
  make CXXFLAGS="-I${LOGPP} -I${CONVPP} -fPIC"
}

post_make_target() {
	# reorganize build folder
	DIR=$(get_build_dir _libnetpp)
	mkdir ${DIR}/libnet++
	cp *.h ${DIR}/libnet++
	ln -s _libnetpp*.a libnet++.a
}
