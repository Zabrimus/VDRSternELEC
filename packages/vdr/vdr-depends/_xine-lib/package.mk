# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_xine-lib"
PKG_VERSION="135913a32b37"
PKG_SHA256="d204befd5643d82f5cf402ed510fc0fd959c7baef1dea61518608baa0dfa0e69"
PKG_LICENSE="GPL LPGL"
PKG_SITE="https://www.xine-project.org"
PKG_URL="http://hg.code.sf.net/p/xine/xine-lib-1.2/archive/${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain _libextractor _directfb2"
PKG_LONGDESC="Multimedia playback engine"
PKG_BUILD_FLAGS="+pic"
PKG_SOURCE_DIR="xine-lib-1-2-${PKG_VERSION}"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --enable-directfb \
						   --enable-fb \
						   --enable-opengl \
						   --enable-glu \
						   --enable-xinerama \
						   --enable-vdpau \
						   --enable-vaapi \
						   --enable-v4l2 \
						   --enable-vdr \
						   --enable-avformat \
						   --with-x \
						   --with-alsa \
						   "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"

  autoreconf -fi
}
