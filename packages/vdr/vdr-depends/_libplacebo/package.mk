# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libplacebo"
PKG_VERSION="4.208.0"
PKG_SHA256="5090fbad4f65b9c950028c1e0dd86d20aa66d159c0854a89b3eb8d4210966b73"
PKG_LICENSE="LGPL2.1"
PKG_SITE="https://code.videolan.org/videolan/libplacebo"
PKG_URL="https://github.com/haasn/libplacebo/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain spirv-headers spirv-tools lcms2 _libshaderc libepoxy"
PKG_LONGDESC="eusable library for GPU-accelerated image/video processing primitives and shaders,"
PKG_BUILD_FLAGS="+pic"

PKG_MESON_OPTS_TARGET="--prefix=/usr/local \
					   --bindir=/usr/local/bin \
					   --libexecdir=/usr/local/bin \
					   --sbindir=/usr/local/sbin \
					   --libdir=/usr/local/lib \
					   -Ddemos=false \
					   "