# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_librsvg"
# PKG_VERSION="fb67478360b8b09a7b2cf52adedf95b02dd8c1df"
# PKG_SHA256="4717ea3b342036a7f8612085ea84f01f21bb3822cc7c19a067e9895a37c7cebc"
# PKG_URL="https://gitlab.gnome.org/GNOME/librsvg/-/archive/${PKG_VERSION}/librsvg-${PKG_VERSION}.tar.gz"

PKG_VERSION="2.54"
PKG_SHA256="baf8ebc147f146b4261bb3d0cd0fac944bf8dbb4b1f2347d23341f974dcc3085"
PKG_LICENSE="LGPL 2.1"
PKG_SITE="https://gitlab.gnome.org/GNOME/librsvg.git"
PKG_URL="https://download.gnome.org/sources/librsvg/${PKG_VERSION}/librsvg-${PKG_VERSION}.0.tar.xz"
PKG_BRANCH="main"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain cairo _rust gdk-pixbuf pango glib libjpeg-turbo libXft libpng jasper shared-mime-info tiff freetype"
PKG_DEPENDS_CONFIG="shared-mime-info pango gdk-pixbuf pango libXft"
PKG_LONGDESC="A library to render SVG images to Cairo surfaces."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"
PKG_DEPENDS_UNPACK="_rust"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_z_zlibVersion=yes \
                           --enable-shared \
                           --disable-static  \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           --enable-introspection=no \
                           --disable-pixbuf-loader \
                           --prefix=/usr/local \
						   --bindir=/usr/local/bin \
                           --libdir=/usr/local/lib \
                           --libexecdir=/usr/local/bin \
                           --sbindir=/usr/local/sbin \
                           "

PKG_CONFIGURE_OPTS_HOST="-disable-static --enable-shared"

if [ "${TARGET_ARCH}" = arm  ]; then
	PKG_CONFIGURE_OPTS_TARGET+=" --target=armv7-unknown-linux-gnueabihf --host=armv7-unknown-linux-gnueabihf "
elif [ "${TARGET_ARCH}" = aarch64  ]; then
	PKG_CONFIGURE_OPTS_TARGET+=" --target=aarch64-unknown-linux-gnu --host=aarch64-unknown-linux-gnu "
elif [ "${TARGET_ARCH}" = x86_64  ]; then
	PKG_CONFIGURE_OPTS_TARGET+=" --target=x86_64-unknown-linux-gnu --host=x86_64-unknown-linux-gnu "
fi;

make_target() {
	make
}

pre_configure_target() {
  cd $(get_build_dir _librsvg)
  aclocal --install || exit 1
  autoreconf --verbose --force --install || exit 1

  export CPPFLAGS="${CPPFLAGS} -I${SYSROOT_PREFIX}/usr/include"
  . "$(get_build_dir _rust)/cargo/env"

  export PKG_CONFIG_PATH="$(get_install_dir shared-mime-info)/usr/share/pkgconfig":"$(get_install_dir pango)/usr/lib/pkgconfig":"$(get_install_dir libXft)/usr/lib/pkgconfig":${PKG_CONFIG_PATH}

  export PATH="${SYSROOT_PREFIX}/usr/local/bin":$PATH
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export CFLAGS="-I${SYSROOT}/usr/local/include"
}
