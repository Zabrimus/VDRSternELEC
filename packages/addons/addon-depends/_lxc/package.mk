# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_lxc"
PKG_VERSION="6.0.0"
PKG_SHA256="ddc274df634927f514cf8a2d9f07ae4af01ea97d3fa1bf93fcf5c7bf6c8d6c34"
PKG_LICENSE="LGPL 2.1"
PKG_SITE="https://github.com/lxc/lxc"
PKG_URL="https://github.com/lxc/lxc/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="lxc-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="LXC is a userspace interface for the Linux kernel containment features."
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"

PKG_MESON_OPTS_TARGET="--prefix=/storage/.kodi/addons/service.incus \
					   --bindir=/storage/.kodi/addons/service.incus/bin \
					   --sbindir=/storage/.kodi/addons/service.incus/bin \
					   --sysconfdir=/storage/.kodi/addons/service.incus/etc \
					   --libexecdir=/storage/.kodi/addons/service.incus/lib \
					   --libdir=/storage/.kodi/addons/service.incus/lib \
					   --datadir=/storage/.kodi/addons/service.incus/data \
					   -Dexamples=false \
					   -Dinit-script=systemd \
					   -Dtests=false \
					   -Dtools=false \
					   -Dtools-multicall=true \
					   -Dapparmor=false \
					   -Dman=false \
					  "

#	meson setup --prefix=/usr \
#	 			--bindir=/usr/bin \
#	 			--sbindir=/usr/sbin \
#	 			--sysconfdir=/etc \
#	 			 --libdir=/usr/lib \
#	 			 --libexecdir=/usr/lib \
#	 			 --localstatedir=/var \
#	 			 --buildtype=plain \
#	 			 -Dstrip=true
# --cross-file=/home/rh/projekte/VDRSternELEC/CoreELEC/build.CoreELEC-Amlogic-no.aarch64-22/build/_lxc-6.0.0/.aarch64-libreelec-linux-gnu/meson.conf
# -Dprefix=/storage/.kodi/addons/service.incus
# -Dexamples=false
# -Dinit-script=systemd
# -Dtests=false
# -Dtools=false
# -Dtools-multicall=true
# -Dapparmor=false
# -Dman=false
# /home/rh/projekte/VDRSternELEC/CoreELEC/build.CoreELEC-Amlogic-no.aarch64-22/build/_lxc-6.0.0
