# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-drmdevice"

PKG_VERSION="5a504eec8803a78bc0e4f198ed42b0a922bc00c9"
PKG_SHA256="ab2f8dd5fa592bea80d01c64cd34dfb426f4e2c0ebe12d36f760f4c8e715f61a"
PKG_SITE="https://github.com/rellla/vdr-plugin-drmdevice"
PKG_URL="https://github.com/rellla/vdr-plugin-drmdevice/archive/${PKG_VERSION}.zip"
PKG_BRANCH="main"
PKG_LICENSE="GPL"
PKG_SOURCE_DIR="vdr-plugin-drmdevice-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm vdr-helper mesa"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="VDR Output Device (drmdevice)"
PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
  export GIT_DESCRIBE="-$(echo ${PKG_VERSION:0:7})"
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
