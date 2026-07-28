# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tools"
PKG_VERSION=""
PKG_LICENSE=""
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain zstd"
PKG_SECTION="virtual"
PKG_LONGDESC="Tools which can be useful"

PKG_DEPENDS_TARGET+=" _triggerhappy _irmplircd _vlc _netcat _irmpconfig"

# disabled for 32-Bit architecture, due to compile problems with kernel printk calls
# cc1: all warnings being treated as errors
# see https://lkml.org/lkml/2026/7/21/2497
if [ ! "${ARCH}" = "arm" ] && [ "${DISTRO}" = "LibreELEC" ]; then
	PKG_DEPENDS_TARGET+=" _vtuner-ng"
fi

# reintegrate eventlircd for LibreELEC
if [ ! "${DISPLAYSERVER}" = "x11" ] && [ "${DISTRO}" = "LibreELEC" ]; then
	PKG_DEPENDS_TARGET+=" _eventlircd"
fi

if [ "${DISTRO}" = "CoreELEC" ]; then
	PKG_DEPENDS_TARGET+=" _amremote _python-evdev"
fi

if [ "${DISTRO}" = "LibreELEC" ] && ([ "${DEVICE}" = "RPi4" ] || [ "${DEVICE}" = "RPi5" ]); then
	PKG_DEPENDS_TARGET+=" _drm-vc4-grabber"
fi

# Entware support
if [ "${DISTRO}" = "LibreELEC" ]; then
  PKG_DEPENDS_TARGET+=" _entware"
fi
