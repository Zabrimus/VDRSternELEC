# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libextractor"
PKG_VERSION="1.11"
PKG_SHA256="16f633ab8746a38547c4a1da3f4591192b0825ad83c4336f0575b85843d8bd8f"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gnu.org/software/libextractor"
PKG_URL="https://ftp.gnu.org/gnu/libextractor/libextractor-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="GNU Libextractor is a library used to extract meta data from files."
PKG_BUILD_FLAGS="+pic +speed"
# PKG_SOURCE_DIR="xine-lib-1-2-${PKG_VERSION}"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
