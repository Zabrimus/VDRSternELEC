# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_cef"
PKG_VERSION="126.2.7"
PKG_LICENSE="unknown"
PKG_SITE="https://cef-builds.spotifycdn.com/"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Chromium Embedded Framework"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed -sysroot"

makeinstall_target() {
  CEF_DIR="${PKG_BUILD}/../../../../cef"
  CEF_URL="https://cef-builds.spotifycdn.com/"
  CEF_FILE_X86="cef_binary_126.2.7%2Bg300bb05%2Bchromium-126.0.6478.115_linux64_minimal.tar.bz2"
  CEF_FILE_ARM64="cef_binary_126.2.7%2Bg300bb05%2Bchromium-126.0.6478.115_linuxarm64_minimal.tar.bz2"
  CEF_FILE_ARM="cef_binary_126.2.7%2Bg300bb05%2Bchromium-126.0.6478.115_linuxarm_minimal.tar.bz2"

  case "${ARCH}" in
    arm)     CEF_FILE=${CEF_FILE_ARM};;
    aarch64) CEF_FILE=${CEF_FILE_ARM64};;
    x86_64)  CEF_FILE=${CEF_FILE_X86};;
  esac

# download cef if necessary
  if [ ! -e ${PKG_BUILD}/../../../sources/${PKG_NAME}/${CEF_FILE} ]; then
    mkdir -p ${PKG_BUILD}/../../../sources/${PKG_NAME}
    curl -L ${CEF_URL}${CEF_FILE} -o ${PKG_BUILD}/../../../sources/${PKG_NAME}/${CEF_FILE}
  fi

# unpack if necessary
  if [ ! -e ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/Release/libcef.so ]; then
    mkdir -p "${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}"
    tar -C ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/ -xf ${PKG_BUILD}/../../../sources/${PKG_NAME}/${CEF_FILE}
    mv ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/cef_binary*/* ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}
    rm -rf ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/cef_binary*
  fi

# package cef binaries external
#  if [ ! -e ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}.zip ]; then
#    mkdir -p ${INSTALL}/storage/cef
#    cd ${INSTALL}
#    cp -R ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/Release/* ${INSTALL}/storage/cef
#    cp -R ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/Resources/* ${INSTALL}/storage/cef
#    zip -qrum9 ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}.zip storage
#  fi

  echo "${PKG_VERSION}" > ${PKG_BUILD}/VERSION
}
