# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_cefbrowser"
PKG_VERSION="8c01b41a5e8a6bf1868a3205e3d44761c0b9b93d"
PKG_SHA256="7f485d223c09878bac3f133a08740327afc3c13018e958c6b8d591e2bd3e5231"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/Zabrimus/cefbrowser"
PKG_URL="https://github.com/Zabrimus/cefbrowser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="cefbrowser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain atk libxml2 cef-at-spi2-atk cups cef-at-spi2-core \
                    libXcomposite libXdamage libXfixes libXrandr libXi libXft openssl _cef"
PKG_NEED_UNPACK="$(get_pkg_directory _cef)"
PKG_LONGDESC="cefbrowser"
PKG_TOOLCHAIN="meson"

CEF_PREFIX="/storage"

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
                       --bindir=${CEF_PREFIX}/cefbrowser \
                       --libexecdir=${CEF_PREFIX}/cefbrowser \
                       --sbindir=${CEF_PREFIX}/cefbrowser \
                       --libdir=${CEF_PREFIX}/cefbrowser"

pre_configure_target() {
   export SSL_CERT_FILE=$(get_install_dir openssl)/etc/ssl/cacert.pem.system
   ln -s $(get_build_dir _cef)/cefbrowser ${PKG_BUILD}/subprojects/cef
}

pre_make_target() {
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/lib

  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  zip -qrum9 ${INSTALL}/usr/local/config/cef-sample-config.zip storage/cefbrowser
}
