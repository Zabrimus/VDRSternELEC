# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_MP_Logos"
PKG_VERSION="ef71b829f1a0ace857ffa77720deee0fd81d23ba"
PKG_SHA256="56d2efd3e5979e9e09d03fe3c7d3cc11cbaed14db0096c4e8a68153e1c26067a"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/MegaV0lt/MP_Logos"
PKG_URL="https://github.com/MegaV0lt/MP_Logos/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="MP_Logos-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _mediaportal-de-logos"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

make_target() {
    export MP_LOGODIR="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles"
    export MAPPING="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles/LogoMapping.xml"
    export AUTO_UPDATE="false"
    export CLEAN_LINKS="false"
    export TO_LOWER="A-Z"

    touch ${PKG_BUILD}/mp_logos.conf
    cd ${MP_LOGODIR}

# Link "Light" variant
    export LOGO_VARIANT="Light"
    export LOGODIR="${PKG_BUILD}/logos${LOGO_VARIANT}"
    mkdir -p ${LOGODIR}
    bash ${PKG_BUILD}/mp_logos.sh -c ${PKG_BUILD}/mp_logos.conf
    mkdir -p ${INSTALL}/usr/local/vdrshare/logos${LOGO_VARIANT}
    cp -R ${LOGODIR} ${INSTALL}/usr/local/vdrshare

# Link "Dark" variant
    export LOGO_VARIANT="Dark"
    export LOGODIR="${PKG_BUILD}/logos${LOGO_VARIANT}"
    mkdir -p ${LOGODIR}
    bash ${PKG_BUILD}/mp_logos.sh -c ${PKG_BUILD}/mp_logos.conf
    mkdir -p ${INSTALL}/usr/local/vdrshare/logos${LOGO_VARIANT}
    cp -R ${LOGODIR} ${INSTALL}/usr/local/vdrshare
}
