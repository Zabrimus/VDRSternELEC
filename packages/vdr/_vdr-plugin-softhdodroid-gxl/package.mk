# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhdodroid-gxl"
PKG_VERSION="c75de19e05522ca71224036489e888661509b4af"
PKG_SHA256="07cac561988cf0cc0de6f1debf33f77bc93bee048c084d9412f2bddcaf749b02"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/jojo61/vdr-plugin-softhdodroid"
PKG_URL="https://github.com/jojo61/vdr-plugin-softhdodroid/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-softhdodroid-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm vdr-helper"
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
