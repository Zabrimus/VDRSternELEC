# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice_vdagent"
PKG_VERSION="0.22.1"
PKG_SHA256="060faea068b41f48104c5a6cb80c6a91f361c3bbf813becf83beedf57302be37"
PKG_LICENSE="GPL3"
PKG_SITE="https://gitlab.freedesktop.org/spice/linux/vd_agent"
PKG_URL="https://gitlab.freedesktop.org/spice/linux/vd_agent/-/archive/spice-vdagent-${PKG_VERSION}/vd_agent-spice-vdagent-${PKG_VERSION}.tar"
PKG_DEPENDS_TARGET="toolchain _spice-protocol libXext libXrandr libXinerama dbus"
PKG_LONGDESC="Spice agent for Linux"
PKG_TOOLCHAIN="configure"

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
#  enable_service spice-vdagent
#  enable_service spice-vdagentd
#}

