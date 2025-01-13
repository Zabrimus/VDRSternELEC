# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_vlc"
PKG_VERSION="7b58309ae72af83d2053bd88f0529e7addaddc6f"
PKG_SHA256="14505af66ac5760abff02b29797cc8c6932e6466589694accc74c9c96b746bb2"
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
                           --disable-vdpau"

pre_configure_target() {
  export LDSHARED="${CC} -shared"
  ./bootstrap
}
