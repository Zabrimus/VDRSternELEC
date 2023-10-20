# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice_vdagent"
PKG_VERSION="bcbbea34d93d07d33b767f808ff3adf628b1ea0f"
PKG_SHA256="ef8d2bb8ec67bd86de63b5e16fc005ae0fa197752a49c99aa4c97838a74591ea"
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

