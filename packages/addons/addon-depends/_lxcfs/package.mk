# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_lxcfs"
PKG_VERSION="6.0.0"
PKG_SHA256="1b680527ce234fed90b6ef64d83afdbfe5b0127346eb5d09465c8ce568aac19c"
PKG_LICENSE="LGPL 2.1"
PKG_SITE="https://github.com/lxc/lxcfs"
PKG_URL="https://github.com/lxc/lxcfs/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse3"
PKG_SOURCE_DIR="lxcfs-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="FUSE filesystem for LXC"
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed"

PKG_MESON_OPTS_TARGET="--prefix=/storage/.kodi/addons/service.incus \
					   --bindir=/storage/.kodi/addons/service.incus/bin \
					   --sbindir=/storage/.kodi/addons/service.incus/bin \
					   --sysconfdir=/storage/.kodi/addons/service.incus/etc \
					   --libexecdir=/storage/.kodi/addons/service.incus/lib \
					   --libdir=/storage/.kodi/addons/service.incus/lib \
					   --datadir=/storage/.kodi/addons/service.incus/data \
					   -Dinit-script=systemd \
					   -Ddocs=false \
					  "
