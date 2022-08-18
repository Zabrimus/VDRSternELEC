# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_jansson"
PKG_VERSION="2.14"
PKG_SHA256="fba956f27c6ae56ce6dfd52fbf9d20254aad42821f74fa52f83957625294afb9"
PKG_LICENSE="MIT"
PKG_SITE="www.digip.org/jansson/"
PKG_URL="https://github.com/akheron/jansson/releases/download/v${PKG_VERSION}/jansson-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Jansson is a C library for encoding, decoding and manipulating JSON data."

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}
