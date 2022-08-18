# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libid3tag"
PKG_VERSION="0.15.1b"
PKG_SHA256="63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151"
PKG_LICENSE="GPL"
PKG_SITE="https://www.underbit.com/products/mad/"
PKG_URL="ftp://ftp.mars.org/pub/mpeg/libid3tag-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_LONGDESC="A library for id3 tagging."

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared"

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}

make_target() {
  make CFLAGS="-fPIC"
}
