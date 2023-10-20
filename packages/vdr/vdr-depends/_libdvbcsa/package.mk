# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libdvbcsa"
PKG_VERSION="8d3ab76a601bf302188fdfe5da5a1849a3eaefbb"
PKG_SHA256="8b9e1ba9ff9cae8e085e52872f4a9dcadea4d80273a1026ebd60c27658a77d36"
PKG_LICENSE="LGPL"
PKG_SITE="https://www.videolan.org/developers/libdvbcsa.html"
PKG_URL="https://github.com/pinkflozd/libdvbcsa/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="libdvbcsa-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A implementation of DVB/CSA, with encryption and decryption capabilities."
PKG_TOOLCHAIN="autotools"
# libdvbcsa is a bit faster without LTO, and tests will fail with gcc-5.x
PKG_BUILD_FLAGS="+pic +speed"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-sysroot=${SYSROOT_PREFIX}"

if target_has_feature neon; then
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-neon"
elif [ "${TARGET_ARCH}" = x86_64  ]; then
  if target_has_feature ssse3; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-ssse3"
  elif target_has_feature sse2; then
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-sse2"
  else
    PKG_CONFIGURE_OPTS_TARGET+=" --enable-uint64"
  fi
fi
