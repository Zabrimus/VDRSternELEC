# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice_vdagent"
PKG_VERSION="8b0f9cf1e207eb1160d8b453a77b662e783ea9d7"
PKG_SHA256="3c66904fe5a2f661cbc3fdf82be3cf79b1935951ec6b0f6fb7ac4011e69b0ec8"
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

