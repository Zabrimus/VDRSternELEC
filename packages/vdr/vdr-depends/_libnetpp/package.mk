# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libnetpp"
PKG_VERSION="b32ecc8e64508f3b1158a2adcbd82034c71d7a38"
PKG_SHA256="fd63342180961ad5818b3c2bfa4f15ec383e223e324734bfe57527442e580223"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/jowi24/libnetpp"
PKG_URL="https://github.com/jowi24/libnetpp/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="libnetpp-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _liblogpp boost"
PKG_LONGDESC="TODO"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
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
