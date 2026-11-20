# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-drmdevice"

PKG_VERSION="643e8352e90f6e36530fb0e905f73ff08dc162eb"
PKG_SHA256="d9e8fab3526c5accfee8fd612bc58bdfc2fcc0cdc098e2e34f9e7be2f57c97d1"
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

pre_patch() {
  UNPATCHED_SOURCES="$(cd ${PKG_BUILD} && find . -type f -exec md5sum {} + | sort)"
}

post_patch() {
  if [ "$(cd ${PKG_BUILD} && find . -type f -exec md5sum {} + | sort)" != "${UNPATCHED_SOURCES}" ]; then
    touch ${PKG_BUILD}/.patched
  fi
}

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig

  # only the version on a tag of upstream, the abbreviated hash otherwise
  if timeout 20 git ls-remote --tags ${PKG_SITE} 2>/dev/null | grep -q "^${PKG_VERSION}[[:space:]]"; then
    GIT_DESCRIBE=""
  else
    GIT_DESCRIBE="-${PKG_VERSION:0:7}"
  fi
  [ -f ${PKG_BUILD}/.patched ] && GIT_DESCRIBE+="-patched"
  export GIT_DESCRIBE
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
