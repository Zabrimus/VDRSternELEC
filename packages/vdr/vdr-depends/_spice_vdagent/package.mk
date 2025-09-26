# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice_vdagent"
PKG_VERSION="761770bf10455563375a022315039779bf8aac36"
PKG_SHA256="a80d561aa895f8d278e61c1cba3ed2c8093c64176681de97acf223d6f7d6bee7"
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

