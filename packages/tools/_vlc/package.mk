# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_vlc"
PKG_VERSION="79128878ddb2c280bbb6c89c76a46b31a80ade1c"
PKG_SHA256="f6d93944a1d12213d31ee6c027b8a85c95b1f6f81f69d61dbf54d3076752db44"
PKG_LICENSE=""
PKG_SITE="https://www.videolan.org/vlc/"
PKG_URL="https://code.videolan.org/videolan/vlc/-/archive/${PKG_VERSION}/vlc-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg flac _libmad libvorbis mpg123 soxr libogg taglib libarchive libmpeg2 _libdvbpsi libgcrypt gnutls libmtp libusb"
PKG_SOURCE_DIR="vlc-${PKG_VERSION}"
PKG_LONGDESC="VLC media player is a highly portable multimedia player"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--disable-lua \
						   --disable-a52 \
                           --disable-qt \
                           --enable-run-as-root \
                           --without-x \
                           --disable-xcb \
                           --disable-goom \
                           --disable-projectm \
                           --disable-vsxu \
                           --enable-merge-ffmpeg \
                           --disable-gles2 \
                           --disable-xvideo \
                           --disable-sdl-image \
                           --disable-vdpau \
                           --disable-gst-decode \
                           --disable-nfs"


post_unpack() {
    # rm outdated patch if it still exists
    rm -f ${PKG_DIR}/patches/vlc-3.0.21-ffmpeg8-1.patch
}

pre_configure_target() {
  export LDSHARED="${CC} -shared"

  cd $(get_build_dir _vlc)
  if [ -e bootstrap ]; then
  	./bootstrap
  fi
}
