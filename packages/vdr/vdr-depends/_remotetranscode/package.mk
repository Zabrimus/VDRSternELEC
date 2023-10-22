# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_remotetranscode"
PKG_VERSION="5c57d8c76124e0400db5962eb9b3c9f8f3fc8136"
PKG_SHA256="eb273d446762af8ee6e677d58a31528da5d93c01f36418aac8ed7fcdcc466bdf"
PKG_LICENSE="unknown"
PKG_SITE="https://github.com/Zabrimus/remotetranscode"
PKG_URL="https://github.com/Zabrimus/remotetranscode/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="remotetranscode-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain ffmpeg-tools"
PKG_LONGDESC="remotetranscode"
PKG_TOOLCHAIN="meson"

RT_PREFIX="/storage"

PKG_MESON_OPTS_TARGET="--prefix=${RT_PREFIX} \
                       --bindir=${RT_PREFIX}/remotetranscode \
                       --libexecdir=${RT_PREFIX}/remotetranscode \
                       --sbindir=${RT_PREFIX}/remotetranscode \
                       --libdir=${RT_PREFIX}/remotetranscode"

pre_configure_target() {
   export SSL_CERT_FILE=$(get_install_dir openssl)/etc/ssl/cacert.pem.system
}

pre_make_target() {
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  cd ${INSTALL}

  # install binary in /usr/local/bin
  mkdir -p ${INSTALL}/usr/local/bin
  cp storage/remotetranscode/remotrans ${INSTALL}/usr/local/bin
  rm storage/remotetranscode/remotrans

  # copy system.d start script
  mkdir -p ${INSTALL}/storage/.config/system.d
  cp ${PKG_DIR}/_system.d/remotetranscode.service ${INSTALL}/storage/.config/system.d

  # zip remotranscode static files
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  zip -qrum9 ${INSTALL}/usr/local/config/web-remotetranscode.zip storage
}
