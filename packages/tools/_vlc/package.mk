# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_vlc"
PKG_VERSION="10aa0e6e1bba557409c9173c89dd3a9c199fccd4"
PKG_SHA256="8f1c780a3b05d27b2edae073a9ce72167afad7e17eba198f8f6bc668a19c33fa"
PKG_LICENSE=""
PKG_SITE="https://www.videolan.org/vlc/"
PKG_URL="https://code.videolan.org/videolan/vlc/-/archive/${PKG_VERSION}/vlc-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg flac libmad libvorbis mpg123 soxr libogg taglib libarchive libmpeg2 _libdvbpsi libgcrypt gnutls libmtp libusb"
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
                           --disable-nfs"

pre_configure_target() {
  export LDSHARED="${CC} -shared"
  ./bootstrap
}
