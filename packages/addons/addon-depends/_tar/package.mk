# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_tar"
PKG_VERSION="1.35"
PKG_SHA256="14d55e32063ea9526e057fbf35fcabd53378e769787eff7919c3755b02d2b57e"
PKG_LICENSE="BSD/GPLv2"
PKG_SITE="https://github.com/facebook/zstd"
PKG_URL="https://ftp.gnu.org/gnu/tar/tar-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain make:host"
PKG_LONGDESC="tar"
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed -sysroot"