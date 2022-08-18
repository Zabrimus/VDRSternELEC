# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libconvpp"
PKG_VERSION="286a289e30417ac534c861529ae245ccb44286e5"
PKG_SHA256="1b8f8f0db94c7905589b960cc3017a2abbb0107b4d076493c92932ba0cace949"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/jowi24/libnetpp"
PKG_URL="https://github.com/jowi24/libconvpp/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="libconvpp-${PKG_VERSION}"
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
	DIR=$(get_build_dir _libconvpp)
	mkdir ${DIR}/libconv++
	cp *.h ${DIR}/libconv++
	ln -s _libconvpp*.a libconv++.a
}
