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

PKG_MESON_OPTS_TARGET="--prefix=${VDR_PREFIX} \
					   --bindir=${VDR_PREFIX}/bin \
					   --libexecdir=${VDR_PREFIX}/bin \
					   --sbindir=${VDR_PREFIX}/sbin \
					   --libdir=${VDR_PREFIX}/lib"

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi

  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}${VDR_PREFIX}/lib"
}
