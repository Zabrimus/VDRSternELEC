# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_cefbrowser"
PKG_VERSION="812a810c514b6ab7e2885b73b14b1b14cfdb5d8b"
PKG_SHA256="5c5e0a232ba8c40747c0a8494914f57cec9cfa28cd98793c2f2a90886ed1bb71"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/Zabrimus/cefbrowser"
PKG_URL="https://github.com/Zabrimus/cefbrowser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="cefbrowser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain atk libxml2 cups cef-at-spi2-core \
                    libXcomposite libXdamage libXfixes libXrandr libXi libXft openssl _cef"
PKG_NEED_UNPACK="$(get_pkg_directory _cef)"
PKG_DEPENDS_CONFIG="_cef"
PKG_LONGDESC="cefbrowser"
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed"

# CoreELEC >= 21
if [ "${DISTRONAME}" = "CoreELEC" ] && [ ${OS_MAJOR} -ge 21 ]; then
   PKG_DEPENDS_TARGET += "cef-at-spi2-atk"
fi

# LibreELEC >= 12
if [ "${DISTRONAME}" = "LibreELEC" ] && [ ${OS_MAJOR} -ge 12 ]; then
   PKG_DEPENDS_TARGET += "cef-at-spi2-atk"
fi

CEF_PREFIX="/usr/local"
CEF_DIR="$(get_build_dir _cef)/../../../../cef"
CEF_VERSION_FILE="$(get_build_dir _cef)/VERSION"
CEF_VERSION="$(cat ${CEF_VERSION_FILE})"

case "${ARCH}" in
  arm)     DARCH="arm";;
  aarch64) DARCH="arm64";;
  x86_64)  DARCH="x86";;
esac

case "${ARCH}" in
  arm)     DSUBARCH=${TARGET_SUBARCH};;
  aarch64) DSUBARCH=${TARGET_VARIANT};;
  x86_64)  DSUBARCH=${TARGET_SUBARCH};;
esac

PKG_MESON_OPTS_TARGET="-Darch=${DARCH} -Dsubarch=${DSUBARCH} \
                       --prefix=${CEF_PREFIX} \
                       --bindir=${CEF_PREFIX}/bin \
                       --libdir=${CEF_PREFIX}/lib \
                       --libexecdir=${CEF_PREFIX}/lib \
                       --sbindir=${CEF_PREFIX}/bin"

pre_configure_target() {
   export SSL_CERT_FILE=$(get_install_dir openssl)/etc/ssl/cacert.pem.system
   rm -rf ${PKG_BUILD}/subprojects/cef
   ln -s ${CEF_DIR}/cef-${CEF_VERSION}-${ARCH} ${PKG_BUILD}/subprojects/cef
}

pre_make_target() {
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/lib
  mkdir -p ${INSTALL}/storage/cefbrowser-sample/data
  mv ${INSTALL}/usr/local/cefbrowser/* ${INSTALL}/storage/cefbrowser-sample/data
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample
  cp -r ${PKG_BUILD}/config/* ${INSTALL}/storage/.config/vdropt-sample
  mkdir -p ${INSTALL}/usr/local/system.d
  cp ${PKG_DIR}/_system.d/* ${INSTALL}/usr/local/system.d
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  zip -qrum9 ${INSTALL}/usr/local/config/web-cefbrowser-sample.zip storage/cefbrowser-sample
  zip -qrum9 ${INSTALL}/usr/local/config/cefbrowser-sample-config.zip storage/.config
}
