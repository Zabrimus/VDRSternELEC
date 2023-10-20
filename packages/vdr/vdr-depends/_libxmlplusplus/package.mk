# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libxmlplusplus"
PKG_VERSION="5.0.1"
PKG_SHA256="15c38307a964fa6199f4da6683a599eb7e63cc89198545b36349b87cf9aa0098"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/libxmlplusplus/libxmlplusplus"
PKG_URL="https://github.com/libxmlplusplus/libxmlplusplus/releases/download/${PKG_VERSION}/libxml++-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libxml++"
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed"

PKG_MESON_OPTS_TARGET="--prefix=/usr/local \
					   --bindir=/usr/local/bin \
					   --libexecdir=/usr/local/bin \
					   --sbindir=/usr/local/sbin \
					   --libdir=/usr/local/lib"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
