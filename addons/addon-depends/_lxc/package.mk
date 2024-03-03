# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_lxc"
PKG_VERSION="5.0.3"
PKG_SHA256="b04b92fd7bf27f8b1281093314c8171e92c45776146d9b41c58cd170db66766b"
PKG_LICENSE="GPL 2"
PKG_SITE="https://github.com/lxc/lxc"
PKG_URL="https://github.com/lxc/lxc/archive/refs/tags/lxc-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="lxc-lxc-${PKG_VERSION}"
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