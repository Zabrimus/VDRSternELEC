# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_boblight"
PKG_VERSION="cebd885453337087fe678aef8082c96ece0a0235"
PKG_SHA256="e6fe377a944d035429b1459221bcbd0d9a67fa16cbcc9810487fe7e513dae51f"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/arvydas/boblight"
PKG_URL="https://github.com/arvydas/boblight/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="boblight-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _portaudio"
PKG_LONGDESC="Boblight with BlinkStick support"
PKG_TOOLCHAIN="configure"

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

  ./autogen.sh noconfig
}

make_target() {
  make CFLAGS="-fPIC"
}
