# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_liblogpp"
PKG_VERSION="d61e25f4548f40261e6db62a967776cfa16e599a"
PKG_SHA256="1f02d69ea34844cc69299087e8db968b1bd8565fb7783965d3a137b0cd1444e1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/jowi24/liblogpp"
PKG_URL="https://github.com/jowi24/liblogpp/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="liblogpp-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
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
  cd ..
  make CXXFLAGS="-fPIC"
}

post_make_target() {
	# reorganize build folder
	DIR=$(get_build_dir _liblogpp)
	mkdir ${DIR}/liblog++
	cp *.h ${DIR}/liblog++
	ln -s _liblogpp*.a liblog++.a
}
