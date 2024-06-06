# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_lxc"
PKG_VERSION="6.0.0"
PKG_SHA256="ddc274df634927f514cf8a2d9f07ae4af01ea97d3fa1bf93fcf5c7bf6c8d6c34"
PKG_LICENSE="GPL 2"
PKG_SITE="https://github.com/lxc/lxc"
PKG_URL="https://github.com/lxc/lxc/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="lxc-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="LXC is a userspace interface for the Linux kernel containment features."
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed"

PKG_MESON_OPTS_TARGET="-Dexamples=false \
					   -Dinit-script=systemd \
					   -Dsystemd-unitdir=TODO \
					   -Dtests=false \
					   -Dtools=false \
					   -Dcommands=false \
					   -Dman=false \
					  "