# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice_vdagent"
PKG_VERSION="f0dc2b098d7a5cb6bd317e0682851b3d9cbc2836"
PKG_SHA256="a3116a1fc3201edbc097bc12410893906ba82bfe6898135beab91fdcd573f0ed"
PKG_LICENSE="GPL3"
PKG_SITE="https://gitlab.freedesktop.org/spice/linux/vd_agent.git"
PKG_URL="https://gitlab.freedesktop.org/spice/linux/vd_agent/-/archive/${PKG_VERSION}/vd_agent-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _spice-protocol libXext libXrandr libXinerama dbus"
PKG_LONGDESC="Spice agent for Linux"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

KG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           --sysconfdir=/usr/local/etc \
                           --with-gnu-ld \
                           --with-pic \
                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"

  autoreconf -fi
}

#post_install() {
#  enable_service spice-vdagent.service
#  enable_service spice-vdagentd.service
#}

