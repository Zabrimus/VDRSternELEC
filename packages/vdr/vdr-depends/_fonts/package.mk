# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_fonts"
PKG_VERSION="99e52de86451d1e125ffcf33ded7115ad6827fd7"
PKG_SHA256="1ec0f109e078f712d779edbbcc171d62ccd885c89e7dabdbc6fe446f2257481e"
PKG_LICENSE="Apache License"
PKG_SITE="https://github.com/Zabrimus/fonts"
PKG_URL="https://github.com/Zabrimus/fonts/archive/${PKG_VERSION}.zip"
PKG_TOOLCHAIN="manual"

unpack() {
  mkdir -p ${PKG_BUILD}/
  cd ${PKG_BUILD}
  unzip ${SOURCES}/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.zip
}

pre_configure_target() {
  # test if prefix is set
  if [ "x${VDR_PREFIX}" = "x" ]; then
      echo "==> VDR_PREFIX is empty, but must be set"
      exit 1
  fi
}

make_target() {
    FONTDIR=$(echo ${PKG_NAME}-${PKG_VERSION} | sed -e s:_::g)

	if [ "${VDR_PREFIX}" = "/usr/local" ]; then
		mkdir -p ${INSTALL}/usr/local/vdrshare/fonts/android
		cp  ${PKG_BUILD}/${FONTDIR}/fonts-android-4.3/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/usr/local/vdrshare/fonts/android/

		mkdir -p ${INSTALL}/usr/local/vdrshare/fonts/sourcesanspro
		cp ${PKG_BUILD}/${FONTDIR}/fonts-sourcesanspro/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/usr/local/vdrshare/fonts/sourcesanspro/

		mkdir -p ${INSTALL}/usr/local/vdrshare/fonts/ds-digital
		cp ${PKG_BUILD}/${FONTDIR}/fonts-ds-digital/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/usr/local/vdrshare/fonts/ds-digital/

		mkdir -p ${INSTALL}/usr/local/vdrshare/fonts/teletext
		cp ${PKG_BUILD}/${FONTDIR}/fonts-teletext/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/usr/local/vdrshare/fonts/teletext/

		mkdir -p ${INSTALL}/usr/local/vdrshare/fonts/vdrsymbols
		cp ${PKG_BUILD}/${FONTDIR}/vdrsymbols/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/usr/local/vdrshare/fonts/vdrsymbols/
	else
		mkdir -p ${INSTALL}/storage/.fonts/android
		cp  ${PKG_BUILD}/${FONTDIR}/fonts-android-4.3/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}//storage/.fonts/android/

		mkdir -p ${INSTALL}/storage/.fonts/sourcesanspro
		cp ${PKG_BUILD}/${FONTDIR}/fonts-sourcesanspro/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/storage/.fonts/sourcesanspro/

		mkdir -p ${INSTALL}/storage/.fonts/ds-digital
		cp ${PKG_BUILD}/${FONTDIR}/fonts-ds-digital/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/storage/.fonts/ds-digital/

		mkdir -p ${INSTALL}/storage/.fonts/teletext
		cp ${PKG_BUILD}/${FONTDIR}/fonts-teletext/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/storage/.fonts/teletext/

		mkdir -p ${INSTALL}/storage/.fonts/vdrsymbols
		cp ${PKG_BUILD}/${FONTDIR}/vdrsymbols/{*.ttf,fonts.dir,fonts.scale} ${INSTALL}/storage/.fonts/vdrsymbols/
	fi
}
