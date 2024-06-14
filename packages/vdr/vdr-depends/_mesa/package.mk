# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_mesa"
PKG_VERSION="24.1.1"
PKG_SHA256="0038826c6f7e88d90b4ce6f719192fa58ca7dedf4edcaa1174cf7bd920ef89ea"
PKG_LICENSE="OSS"
PKG_SITE="http://www.mesa3d.org/"
PKG_URL="https://mesa.freedesktop.org/archive/mesa-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="toolchain:host expat:host libclc:host libdrm:host Mako:host spirv-tools:host"
PKG_DEPENDS_TARGET="toolchain expat libdrm Mako:host"
PKG_LONGDESC="Mesa is a 3-D graphics library with an API."
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_MESON_OPTS_TARGET="-Dgallium-drivers=panfrost \
 					   -Dllvm=disabled \
 					   -Dvulkan-drivers= \
 					   -Dplatforms="" \
 					   -Dopengl=true \
					   -Dgbm=enabled \
                       -Degl=enabled \
                       -Dglx=disabled \
 					   "
