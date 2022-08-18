# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libpngpp"
PKG_VERSION="0.2.10"
PKG_SHA256="998af216ab16ebb88543fbaa2dbb9175855e944775b66f2996fc945c8444eee1"
PKG_LICENSE="GPL2"
PKG_SITE="https://www.nongnu.org/pngpp/"
PKG_URL="http://download.savannah.nongnu.org/releases/pngpp/png++-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="png++-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="PNG++ aims to provide simple yet powerful C++ interface to libpng, the PNG reference implementation library."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}

post_make_target() {
	# reorganize build folder
	DIR=$(get_build_dir _libpngpp)
	mkdir ${DIR}/png++
	cp *.hpp ${DIR}/png++
}
