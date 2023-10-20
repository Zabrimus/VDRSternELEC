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
  mv ${PKG_BUILD}/cef_binary* ${PKG_BUILD}/cefbrowser

  # copy cef binaries to root/cef
  mkdir -p ${PKG_BUILD}/../../../../cef
  rm -f ${PKG_BUILD}/../../../../cef/cef-${ARCH}.tar.bz2
  tar cjvf ${PKG_BUILD}/../../../../cef/cef-${ARCH}.tar.bz2 -C ${PKG_BUILD} cefbrowser/Release/* cefbrowser/Resources/*

  # coreelec-19 needs this
  sed -i "s/VERSION 3.21/VERSION 3.19/" ${PKG_BUILD}/cefbrowser/CMakeLists.txt
}
