# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_boblight"
PKG_VERSION="3fc2090825dfd007a1edf4474c15ec46f7bef0bc"
PKG_SHA256="6b8ef7025a78c349dac0c3e6bbcdfa17c2194a985b6f3da8198444a89b004ba3"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/vdr-projects/boblight"
PKG_URL="https://github.com/vdr-projects/boblight/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="boblight-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _portaudio"
PKG_LONGDESC="Boblight with BlinkStick support"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           --sysconfdir=/usr/local/etc \
                           "

if [ ! "${DISPLAYSERVER}" = "x11" ] ; then
   PKG_CONFIGURE_OPTS_TARGET+=" --without-x11"
fi

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"

  # ./autogen.sh noconfig
}

make_target() {
  make CFLAGS="-fPIC"
}

