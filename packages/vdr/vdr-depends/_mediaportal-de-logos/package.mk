# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_mediaportal-de-logos"
PKG_VERSION="4c43a379c9d80c68aa75aa25262921b4ff52a74c"
PKG_SHA256="795bfbd6ac0c7e8a59cdbf12da0efb372a39b1d1c88306f80da5d79a01ea7de0"
PKG_LICENSE="?"
PKG_SITE="https://github.com/Jasmeet181/mediaportal-de-logos"
PKG_SOURCE_DIR="mediaportal-de-logos-${PKG_VERSION}"
PKG_URL="https://github.com/Jasmeet181/mediaportal-de-logos/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"

make_target() {
    INSTALLPATH="${INSTALL}/usr/local/vdrshare/logofiles"

    mkdir -p ${INSTALLPATH}/Radio/.Light
    cp -R ${PKG_BUILD}/Radio/.Light ${INSTALLPATH}/Radio
    mkdir -p ${INSTALLPATH}/Radio/.Dark
    cp -R ${PKG_BUILD}/Radio/.Dark ${INSTALLPATH}/Radio

    mkdir -p ${INSTALLPATH}/TV/.Light
    cp -R ${PKG_BUILD}/TV/.Light ${INSTALLPATH}/TV
    mkdir -p ${INSTALLPATH}/TV/.Dark
    cp -R ${PKG_BUILD}/TV/.Dark ${INSTALLPATH}/TV

    cp  ${PKG_BUILD}/LogoMapping.xml ${INSTALLPATH}/LogoMapping.xml
}
