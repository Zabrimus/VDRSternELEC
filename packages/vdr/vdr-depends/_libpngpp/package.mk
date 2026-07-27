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
PKG_BUILD_FLAGS="+speed"

makeinstall_target() {
	mkdir -p $(get_install_dir _libpngpp)/usr/local/include/png++
	cp *.hpp $(get_install_dir _libpngpp)/usr/local/include/png++
}
