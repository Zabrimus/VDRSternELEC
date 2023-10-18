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

  # download cef
  if [ ! -e ${PKG_BUILD}/../../../sources/${PKG_NAME}/${CEF_FILE} ]; then
      mkdir -p ${PKG_BUILD}/../../../sources/${PKG_NAME}
      curl -L ${CEF_URL}${CEF_FILE} -o ${PKG_BUILD}/../../../sources/${PKG_NAME}/${CEF_FILE}
  fi
  tar -C ${PKG_BUILD}/ -xf ${PKG_BUILD}/../../../sources/${PKG_NAME}/${CEF_FILE}
  mv ${PKG_BUILD}/cef_binary*/* ${PKG_BUILD}
  rm -rf ${PKG_BUILD}/cef_binary*

  # install cef binaries
  mkdir -p ${INSTALL}/storage/cefbrowser
  cp -R ${PKG_BUILD}/Release/* ${INSTALL}/storage/cefbrowser
  cp -R ${PKG_BUILD}/Resources/* ${INSTALL}/storage/cefbrowser

  # package cef binaries
  cd ${INSTALL}
  if [ ${CEF_BINARIES} ]; then
    mkdir -p ${INSTALL}/usr/local/config
    zip -qrum9 ${INSTALL}/usr/local/config/cef-${ARCH}.zip storage
  else
    mkdir -p ${CEF_DIR}
    rm -f ${CEF_DIR}/cef-${ARCH}.zip
    zip -qrum9 ${CEF_DIR}/cef-${ARCH}.zip storage
  fi

  # coreelec-19 needs this
  sed -i "s/VERSION 3.21/VERSION 3.19/" ${PKG_BUILD}/CMakeLists.txt
}
