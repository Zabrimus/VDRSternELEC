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
