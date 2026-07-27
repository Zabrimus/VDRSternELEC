# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_squashfs-tools"
PKG_VERSION="4.7.2"
PKG_SHA256="4672b5c47d9418d3a5ae5b243defc6d9eae8275b9771022247c6a6082c815914"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/plougher/squashfs-tools"
PKG_URL="https://github.com/plougher/squashfs-tools/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib lzo xz _zstd"
PKG_DEPENDS_UNPACK="_zstd"
PKG_LONGDESC="Tools for squashfs, a highly compressed read-only filesystem for Linux."
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed -sysroot"

make_target() {
  export LDFLAGS="-L$(get_install_dir _zstd)/usr/local/lib"
  make -C squashfs-tools \
          XZ_SUPPORT=1 \
          LZO_SUPPORT=1 \
          ZSTD_SUPPORT=1 \
          XATTR_SUPPORT=1 \
          XATTR_DEFAULT=1 \
          INCLUDEDIR="-I. -I$(get_install_dir zlib)/usr/include -I$(get_install_dir lzo)/usr/include -I$(get_install_dir xz)/usr/include -I$(get_build_dir _zstd)/lib" \
          all
}

#makeinstall() {
#  :
#}
