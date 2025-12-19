# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_mesa"
PKG_VERSION="24.0.8"
PKG_SHA256="d1ed86a266d5b7b8c136ae587ef5618ed1a9837a43440f3713622bf0123bf5c1"
PKG_LICENSE="OSS"
PKG_SITE="http://www.mesa3d.org/"
PKG_URL="https://mesa.freedesktop.org/archive/mesa-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="toolchain:host expat:host libdrm:host Mako:host spirv-tools:host"
PKG_DEPENDS_TARGET="toolchain expat libdrm Mako:host"
PKG_LONGDESC="Mesa is a 3-D graphics library with an API."
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_MESON_OPTS_TARGET="-Dgallium-drivers=panfrost,swrast \
					   -Dosmesa=true \
 					   -Dllvm=disabled \
 					   -Dvulkan-drivers= \
 					   -Dplatforms="" \
 					   -Dopengl=true \
					   -Dgbm=enabled \
                       -Degl=enabled \
                       -Dglx=disabled \
                       -Ddri-drivers-path=/storage/.kodi/addons/service.cefbrowser/lib/private/dri \
                       --prefix=$(get_build_dir _mesa)/private.install \
                       --libdir=$(get_build_dir _mesa)/private.install \
 					   "

makeinstall_target() {
    :
}