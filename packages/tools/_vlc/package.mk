# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_vlc"
PKG_VERSION="3.0.21"
PKG_SHA256="24dbbe1d7dfaeea0994d5def0bbde200177347136dbfe573f5b6a4cee25afbb0"
PKG_LICENSE=""
PKG_SITE="https://www.videolan.org/vlc/"
PKG_URL="http://download.videolan.org/pub/videolan/vlc/${PKG_VERSION}/vlc-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain ffmpeg flac libmad libvorbis mpg123 soxr libogg taglib libarchive libmpeg2 _libdvbpsi libgcrypt gnutls"
PKG_SOURCE_DIR="vlc-${PKG_VERSION}"
PKG_LONGDESC="VLC media player is a highly portable multimedia player"
PKG_TOOLCHAIN="auto"
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
                           --disable-vdpau"

pre_configure_target() {
  export LDSHARED="${CC} -shared"
}
