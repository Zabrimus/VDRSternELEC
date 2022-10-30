# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_portaudio"
PKG_VERSION="a2efb9ac588a2999567e48f4fbfe29e0bd90b35c"
PKG_SHA256="1a630a68b5791d500789d055de1c28db8268027026a8a0e47140765de0a763b1"
PKG_LICENSE="MIT"
PKG_SITE="http://www.portaudio.com/"
PKG_URL="https://github.com/PortAudio/portaudio/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="portaudio-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain alsa"
PKG_LONGDESC="PortAudio is a cross-platform, open-source C language library for real-time audio input and output. "
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           --sysconfdir=/usr/local/etc \
                           --without-oss \
                           --without-jack \
                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  make CFLAGS="-fPIC -I$(get_build_dir _portaudio)/include -I$(get_build_dir _portaudio)/src/common -I$(get_build_dir _portaudio)/src/os/unix"
}
