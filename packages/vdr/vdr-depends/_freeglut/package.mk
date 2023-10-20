# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_freeglut"
PKG_VERSION="3.2.2"
PKG_SHA256="c5944a082df0bba96b5756dddb1f75d0cd72ce27b5395c6c1dde85c2ff297a50"
PKG_LICENSE="MIT"
PKG_SITE="http://freeglut.sourceforge.net/"
PKG_URL="https://github.com/FreeGLUTProject/freeglut/releases/download/v${PKG_VERSION}/freeglut-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libglvnd libXi glu"
PKG_LONGDESC="freeglut is a free-software/open-source alternative to the OpenGL Utility Toolkit (GLUT) library."
PKG_BUILD_FLAGS="+pic +speed"
# PKG_TOOLCHAIN="manual"

PKG_CMAKE_OPTS_TARGET="-DOpenGL_GL_PREFERENCE=GLVND \
					   -DCMAKE_INSTALL_PREFIX=/usr/local \
					   -DFREEGLUT_BUILD_DEMOS=off \
					   -DFREEGLUT_BUILD_SHARED_LIBS=off \
					   -DFREEGLUT_BUILD_STATIC_LIBS=on \
                      "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  # drop all unneeded
  rm -rf ${INSTALL}/usr/local/{bin,share,etc}
}


