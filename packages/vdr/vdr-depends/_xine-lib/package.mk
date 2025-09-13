# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_xine-lib"
PKG_VERSION="1.2.13"
PKG_SHA256="12067c92fe6e7f10db02f566a40644058d4a5d8c9dd26b88e545523f78205a00"
PKG_LICENSE="GPL LPGL"
PKG_SITE="https://www.xine-project.org"
PKG_URL="http://hg.code.sf.net/p/xine/xine-lib-1.2/archive/${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain _libextractor _directfb2 libXext glu mesa libva libglvnd nvidia ffmpeg"
PKG_DEPENDS_CONFIG="mesa"
PKG_LONGDESC="Multimedia playback engine"
PKG_BUILD_FLAGS="+pic"
PKG_SOURCE_DIR="xine-lib-1-2-${PKG_VERSION}"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --enable-directfb \
						   --enable-fb \
						   --enable-opengl \
						   --enable-glu \
						   --enable-xinerama \
						   --disable-vdpau \
						   --disable-vaapi \
						   --disable-dxr3 \
						   --disable-xinerama \
						   --enable-v4l2 \
						   --enable-vdr \
						   --enable-avformat \
						   --disable-nfs \
						   --with-x \
						   --with-alsa \
						   --with-pic \
						   "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"

  if [ -f ./autogen.sh ]; then
  	./autogen.sh noconfig
  fi
}
