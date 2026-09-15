# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhdodroid"
PKG_VERSION="48277807743a0f24a91c84e376fc7ffcbb2d0d7d"
PKG_SHA256="308d54db25d1b01c49ead7a2369aff93a1faa533c9f03d16b0c5dfbecb48b076"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jojo61/vdr-plugin-softhdodroid"
PKG_URL="https://github.com/jojo61/vdr-plugin-softhdodroid/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-softhdodroid-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm vdr-helper libcec"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR Output Device (softhdodroid)"
PKG_MAKE_OPTS_TARGET="KODIBUILD=1"
PKG_MAKEINSTALL_OPTS_TARGET="KODIBUILD=1"
PKG_BUILD_FLAGS="+speed"

if [ "${DISTRO}" = LibreELEC  ]; then
	PKG_DEPENDS_TARGET+=" mesa"
elif [ "${DISTRO}" = CoreELEC  ]; then
	PKG_DEPENDS_TARGET+=" opengl-meson"
fi;

# change version for CE 20 and 21
if [ "${DISTRO}" = "CoreELEC" ] && [ "${OS_VERSION:0:2}" = "20" ]; then
	PKG_VERSION="4cc060b0a089d9b55e6f977046620329c876d902"
	PKG_SHA256="67e5db63a64ff6b38c1566e301dbc13e5e3eecebb0ccfd3fa81c59a63004faef"
elif [ "${DISTRO}" = "CoreELEC" ] && [ "${OS_VERSION:0:2}" = "21" ]; then
	PKG_VERSION="4cc060b0a089d9b55e6f977046620329c876d902"
	PKG_SHA256="67e5db63a64ff6b38c1566e301dbc13e5e3eecebb0ccfd3fa81c59a63004faef"
fi

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
  export GIT_REV=${PKG_VERSION}
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
