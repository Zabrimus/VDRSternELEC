# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_nv-codec-headers"
PKG_VERSION="11.1.5.1"
PKG_SHA256="a28cdde3ac0e9e02c2dde7a1b4de5333b4ac6148a8332ca712da243a3361a0d9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/FFmpeg/nv-codec-headers"
PKG_URL="https://github.com/FFmpeg/nv-codec-headers/releases/download/n${PKG_VERSION}/nv-codec-headers-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="FFmpeg version of headers required to interface with Nvidias codec APIs. Corresponds to Video Codec SDK version 11.1.5."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"
