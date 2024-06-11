# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tools"
PKG_VERSION=""
PKG_LICENSE=""
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="virtual"
PKG_LONGDESC="Tools which can be useful"

PKG_DEPENDS_TARGET+=" _triggerhappy _python-evdev _irmplircd _vtuner-ng"

if [ "${DISTRO}" = "CoreELEC" ]; then
	PKG_DEPENDS_TARGET+=" _amremote"
fi

# Addon Depends which shall be installed in the base image
# It's much easier to build, package and maintain
# PKG_DEPENDS_TARGET+=" _cowsql _dnsmasq _libacl _lxc _lxcfs _raft _squashfs-tools _tar _zstd"