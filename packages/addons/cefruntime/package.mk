# SPDX-License-Identifier: GPL-2.0-or-later

# Runtime of the Chromium Embedded Framework for the cefbrowser addon:
# libcef with its resources and the libraries libcef needs, which are not part of the image.
# It changes only with a new CEF version, the cefbrowser addon stays small.

PKG_NAME="cefruntime"
PKG_VERSION="$(get_pkg_variable _cef PKG_VERSION)"
PKG_LICENSE="BSD"
PKG_SITE="https://bitbucket.org/chromiumembedded/cef"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain _cef atk cups cef-at-spi2-core \
                    cef-libXcomposite cef-libXdamage cef-libXfixes cef-libXrandr cef-libXi cef-libXft \
                    cef-libX11 cef-libXext cef-libxcb cef-libXrender"
PKG_LONGDESC="Runtime of the Chromium Embedded Framework for the cefbrowser"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-sysroot"

PKG_REV="1"
PKG_IS_ADDON="yes"
PKG_SECTION="addon"
PKG_ADDON_NAME="cefruntime"
PKG_ADDON_TYPE="xbmc.service"

# libcef needs libgbm. Use the mesa of the image if it has one (LibreELEC),
# otherwise an own copy in the addon (e.g. CoreELEC with the vendor GPU driver).
if [ "${OPENGLES}" = "mesa" ] || [ "${OPENGL}" = "mesa" ]; then
  CEF_MESA="mesa"
else
  CEF_MESA="_mesa"
  PKG_DEPENDS_TARGET+=" _mesa"
fi

makeinstall_target() {
  :
}

addon() {
  CEF_DIR="$(get_build_dir _cef)/../../../../cef/cef-${PKG_VERSION}-${ARCH}"

  # the runtime of a version is installed in its own directory: /storage/browser/addon.cefruntime/<version>
  RUNTIME="${ADDON_BUILD}/${PKG_ADDON_ID}/${PKG_VERSION}"
  mkdir -p ${RUNTIME}/lib/private

  # libcef and its resources (pak files, icudtl.dat, snapshots, locales)
  cp -Pr ${CEF_DIR}/Release/* ${RUNTIME}/lib/
  cp -Pr ${CEF_DIR}/Resources/* ${RUNTIME}/lib/

  # copy cef-at-spi2-core
  for i in $(find $(get_install_dir cef-at-spi2-core)/usr/lib -name *.so*); do
    if [ -f $i ]; then
      cp -P $i ${RUNTIME}/lib/private
    fi
  done

  # copy cef-at-spi2-atk, if built (older CoreELEC)
  A=$(get_install_dir cef-at-spi2-atk 2>/dev/null) || A=""
  if [ -n "$A" ] && [ -d "$A/usr/lib" ]; then
    for i in $(find $A/usr/lib -name *.so*); do
      if [ -f $i ]; then
        cp -P $i ${RUNTIME}/lib/private
      fi
    done
  fi

  # copy mesa, only the own copy. The mesa of the image is used directly.
  if [ "${CEF_MESA}" = "_mesa" ]; then
    mkdir -p ${RUNTIME}/lib/private/dri
    cp -Pr $(get_install_dir _mesa)/usr/lib/*.so* ${RUNTIME}/lib/private
    cp -Pr $(get_install_dir _mesa)/usr/\$ORIGIN/dri/*.so ${RUNTIME}/lib/private/dri
  fi

  cp -PL $(get_install_dir atk)/usr/lib/libatk-1.0.so.0 ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cups)/usr/lib/libcups.so.2 ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXft)/usr/lib/libXft.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXrandr)/usr/lib/libXrandr.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXcomposite)/usr/lib/libXcomposite.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXdamage)/usr/lib/libXdamage.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXfixes)/usr/lib/libXfixes.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXi)/usr/lib/libXi.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libX11)/usr/lib/libX11*.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXext)/usr/lib/libXext.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libxcb)/usr/lib/libxcb*.so* ${RUNTIME}/lib/private
  cp -PL $(get_install_dir cef-libXrender)/usr/lib/libXrender.so* ${RUNTIME}/lib/private

  rm -f ${RUNTIME}/lib/*.symbols ${RUNTIME}/lib/private/*.symbols || true
}
