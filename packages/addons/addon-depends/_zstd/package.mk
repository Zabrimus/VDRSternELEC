# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_zstd"
PKG_VERSION="1.5.6"
PKG_SHA256="8c29e06cf42aacc1eafc4077ae2ec6c6fcb96a626157e0593d5e82a34fd403c1"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/facebook/zstd"
PKG_URL="https://github.com/facebook/zstd/releases/download/v${PKG_VERSION}/zstd-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain cmake:host make:host"
PKG_LONGDESC="A fast real-time compression algorithm."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+local-cc"

makeinstall_target() {
	mkdir -p $(get_build_dir _zstd)/bindir
	cp $(get_build_dir _zstd)/lib/libzstd.so.${PKG_VERSION} $(get_build_dir _zstd)/bindir
	cd $(get_build_dir _zstd)/bindir
	ln -s libzstd.so.${PKG_VERSION} libzstd.so.1
    ln -s libzstd.so.${PKG_VERSION} libzstd.so
}
