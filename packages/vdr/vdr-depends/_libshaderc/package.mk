# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_libshaderc"
PKG_VERSION="2023.7"
PKG_SHA256="681e1340726a0bf46bea7e31f10cbfe78e01e4446a35d90fedc2b78d400fcdeb"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/google/shaderc"
PKG_URL="https://github.com/google/shaderc/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _glslang"
PKG_LONGDESC="A collection of tools, libraries and tests for shader compilation."
PKG_BUILD_FLAGS="+pic +speed"

PKG_CMAKE_OPTS_TARGET="-DSHADERC_SKIP_TESTS=on \
    				  "
pre_configure_target() {
  mkdir -p ${PKG_BUILD}/third_party
  ln -s -f $(get_build_dir spirv-tools) ${PKG_BUILD}/third_party/spirv-tools
  ln -s -f $(get_build_dir spirv-headers) ${PKG_BUILD}/third_party/spirv-headers
  ln -s -f $(get_build_dir _glslang) ${PKG_BUILD}/third_party/glslang
}
