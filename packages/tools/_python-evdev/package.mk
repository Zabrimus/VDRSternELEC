# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_python-evdev"
PKG_VERSION="2dd6ce6364bb67eedb209f6aa0bace0c18a3a40a"
PKG_SHA256="b802f9e25c6c218facd54780c4b3d6436fb769d51e3aa286df63a382a4c799ab"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/gvalkov/python-evdev"
PKG_URL="https://github.com/gvalkov/python-evdev/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="python-evdev-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain libevdev Python3 distutilscross:host"
PKG_LONGDESC="Python bindings for the Linux input subsystem"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHONXCPREFIX="${SYSROOT_PREFIX}/usr"
  export LDSHARED="${CC} -shared"
  export CFLAGS="${CFLAGS} -fcommon"
  export CPPFLAGS="-I${SYSROOT_PREFIX}/usr/include/${PKG_PYTHON_VERSION} -I$(get_install_dir glibc)/usr/include -I${SYSROOT_PREFIX}/usr/include/linux  ${TARGET_CPPFLAGS} "
}

make_target() {
  python3 setup.py build_ext
}

makeinstall_target() {
  PYTHONXCPREFIX="${SYSROOT_PREFIX}/usr" python3 setup.py install --root=$INSTALL --prefix=/usr
}

#post_makeinstall_target() {
#  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
#  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
#}
