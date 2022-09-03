# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice-protocol"
PKG_VERSION="0.14.4"
PKG_SHA256="e74ee1dd12e04d3e117c548f5510129901b2e76be4c09e71be374f0b55dd22b5"
PKG_LICENSE="GPL3"
PKG_SITE="https://gitlab.freedesktop.org/spice/spice-protocol"
PKG_URL="https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/v${PKG_VERSION}/spice-protocol-v${PKG_VERSION}.tar"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The protocol definition for SPICE project"
PKG_TOOLCHAIN="auto"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
