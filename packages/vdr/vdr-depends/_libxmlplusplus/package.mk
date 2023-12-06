# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_libxmlplusplus"
PKG_VERSION="5.0.3"
PKG_SHA256="13074f59e3288a378cafe9e6847df17f764c23fa29bc94f3305b8bf81efb2cf7"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/libxmlplusplus/libxmlplusplus"
PKG_URL="https://github.com/libxmlplusplus/libxmlplusplus/releases/download/${PKG_VERSION}/libxml++-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libxml2"
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
