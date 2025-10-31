# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libfritzpp"
PKG_VERSION="0b87ad3b75614bfb12473996588cd6fa68a1b2fc"
PKG_SHA256="171394066c33c8138ab2a45eb3d73241f3ba880c1ff79ed4cf600862de7a18cb"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/jowi24/libfritzpp"
PKG_URL="https://github.com/jowi24/libfritzpp/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="libfritzpp-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _libnetpp"
PKG_DEPENDS_UNPACK="_liblogpp _libconvpp _libnetpp"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  LOGPP=$(get_build_dir _liblogpp)
  CONVPP=$(get_build_dir _libconvpp)
  NETPP=$(get_build_dir _libnetpp)

  cd ..
  make CXXFLAGS="-I${LOGPP} -I${CONVPP} -I${NETPP} -fPIC"
}

post_make_target() {
	# reorganize build folder
	DIR=$(get_build_dir _libfritzpp)
	mkdir ${DIR}/libfritz++
	cp *.h ${DIR}/libfritz++
	ln -s _libfritzpp*.a libfritz++.a
}
