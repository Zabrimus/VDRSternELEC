# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libdvdcss"
PKG_VERSION="1.4.3"
PKG_SHA256="233cc92f5dc01c5d3a96f5b3582be7d5cee5a35a52d3a08158745d3d86070079"
PKG_LICENSE="GPL"
PKG_SITE="https://www.videolan.org"
PKG_URL="https://download.videolan.org/pub/libdvdcss/${PKG_VERSION}/libdvdcss-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libdvdcss is a simple library designed for accessing DVDs as a block device without having to bother about the decryption."
PKG_TOOLCHAIN="auto"

make_target() {
  make CXXFLAGS="-fPIC"
}


