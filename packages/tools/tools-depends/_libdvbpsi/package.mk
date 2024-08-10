# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libdvbpsi"
PKG_VERSION="1.3.3"
PKG_SHA256="674a551180a84520eafa178f15228491cd5c6851bcf2b8aebb2cd951930d0c49"
PKG_LICENSE=""
PKG_SITE="https://www.videolan.org/developers/libdvbpsi.html"
PKG_URL="https://download.videolan.org/pub/libdvbpsi/${PKG_VERSION}/libdvbpsi-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="libdvbpsi-${PKG_VERSION}"
PKG_LONGDESC="libdvbpsi is a simple library designed for decoding and generation of MPEG TS and DVB PSI tables"
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed +pic"

pre_configure_target() {
  export LDSHARED="${CC} -shared"
}
