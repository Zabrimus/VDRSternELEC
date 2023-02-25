# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_mediaportal-de-logos"
PKG_VERSION="8eabb30922657c839259795597d2cba35b8af18d"
PKG_SHA256="d596081cfe38fcf51db9bb2a6b3f8bde178b48b67119ee89ede81bd11daeb4d0"
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
