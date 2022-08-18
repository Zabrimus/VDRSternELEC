# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libfritzpp"
PKG_VERSION="c74fd462285ade1054784b97b6dce22d55196c01"
PKG_SHA256="54bd7d01301406b00bb8145fdf9213cd942219ab7553c48ad0fc89a03fba8de4"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/jowi24/libfritzpp"
PKG_URL="https://github.com/jowi24/libfritzpp/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="libfritzpp-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _libnetpp"
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
