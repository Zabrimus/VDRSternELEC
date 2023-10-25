# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_cef"
PKG_VERSION="114.2.11"
PKG_LICENSE="unknown"
PKG_SITE="https://cef-builds.spotifycdn.com/"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Chromium Embedded Framework"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

makeinstall_target() {
  CEF_DIR="${PKG_BUILD}/../../../../cef"
  CEF_PREFIX="/storage"
  CEF_URL="https://cef-builds.spotifycdn.com/"
  CEF_FILE_X86="cef_binary_114.2.11%2Bg87c8807%2Bchromium-114.0.5735.134_linux64_minimal.tar.bz2"
  CEF_FILE_ARM64="cef_binary_114.2.11%2Bg87c8807%2Bchromium-114.0.5735.134_linuxarm64_minimal.tar.bz2"
  CEF_FILE_ARM="cef_binary_114.2.11%2Bg87c8807%2Bchromium-114.0.5735.134_linuxarm_minimal.tar.bz2"

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

  mkdir -p ${INSTALL}/usr/local/share/cef/locales
  cp -R ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/Resources/locales/* ${INSTALL}/usr/local/share/cef/locales

# package cef binaries external
  if [ ! -e ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}.zip ]; then
    mkdir -p ${INSTALL}/storage/cef
    cd ${INSTALL}
    cp -R ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/Release/* ${INSTALL}/storage/cef
    cp -R ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/Resources/* ${INSTALL}/storage/cef
    rm -rf ${INSTALL}/storage/cef/locales
    zip -qrum9 ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}.zip storage
  fi

# package cef binaries into image if wanted
  if [ ${CEF_BINARIES} ]; then
    mkdir -p ${INSTALL}/usr/local/config
    cp -R ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}.zip ${INSTALL}/usr/local/config/cef-binaries.zip
  fi

  echo "${PKG_VERSION}" > ${PKG_BUILD}/VERSION

# coreelec-19 needs this
  sed -i "s/VERSION 3.21/VERSION 3.19/" ${CEF_DIR}/cef-${PKG_VERSION}-${ARCH}/CMakeLists.txt
}
