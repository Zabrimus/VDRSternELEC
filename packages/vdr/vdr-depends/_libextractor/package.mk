# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libextractor"
PKG_VERSION="1.13"
PKG_SHA256="bb8f312c51d202572243f113c6b62d8210301ab30cbaee604f9837d878cdf755"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gnu.org/software/libextractor"
PKG_URL="https://ftp.gnu.org/gnu/libextractor/libextractor-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="GNU Libextractor is a library used to extract meta data from files."
PKG_BUILD_FLAGS="+pic +speed"
# PKG_SOURCE_DIR="xine-lib-1-2-${PKG_VERSION}"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local --disable-shared"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
