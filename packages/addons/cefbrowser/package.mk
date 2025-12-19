# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="cefbrowser"
PKG_VERSION="9c1ca16dc7dcbb2c0a96cb13afac8d1e45c3749f"
PKG_SHA256="358f89d04a50554616507af47527f2bd24fdf7912200490d1072e7f76aa85936"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/Zabrimus/cefbrowser"
PKG_URL="https://github.com/Zabrimus/cefbrowser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="cefbrowser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain atk libxml2 cups cef-at-spi2-core \
                    cef-libXcomposite cef-libXdamage cef-libXfixes cef-libXrandr cef-libXi cef-libXft \
                    cef-libX11 cef-libXext cef-libxcb cef-libXrender \
                    openssl _cef _thrift"
PKG_NEED_UNPACK="$(get_pkg_directory _cef)"
PKG_DEPENDS_UNPACK="_cef"
PKG_DEPENDS_CONFIG="_cef"
PKG_LONGDESC="cefbrowser"
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed -sysroot +strip"

PKG_REV="1"
PKG_SECTION="tools"
PKG_IS_ADDON="yes"
PKG_SECTION="service"
PKG_ADDON_NAME="cefbrowser"
PKG_ADDON_TYPE="xbmc.service"

# CoreELEC <= 20
if [ "${DISTRONAME}" = "CoreELEC" ] && [ "${OS_MAJOR}" -le "20" ]; then
   PKG_DEPENDS_TARGET+=" cef-at-spi2-atk _mesa"
fi

# CoreELEC >= 21
if [ "${DISTRONAME}" = "CoreELEC" ] && [ "${OS_MAJOR}" -ge "21" ]; then
   PKG_DEPENDS_TARGET+=" _mesa"
fi

CEF_PREFIX="/usr/local"

case "${ARCH}" in
  arm)     DARCH="arm";;
  aarch64) DARCH="arm64";;
  x86_64)  DARCH="x86_64";;
esac

case "${ARCH}" in
  arm)     DSUBARCH=${TARGET_SUBARCH};;
  aarch64) DSUBARCH=${TARGET_VARIANT};;
  x86_64)  DSUBARCH="x86-64";;
esac

PKG_MESON_OPTS_TARGET="-Darch=${DARCH} -Dsubarch=${DSUBARCH} -Dvdrsternelec=true \
                       --prefix=${CEF_PREFIX} \
                       --bindir=${CEF_PREFIX}/bin \
                       --libdir=${CEF_PREFIX}/lib \
                       --libexecdir=${CEF_PREFIX}/lib \
                       --sbindir=${CEF_PREFIX}/bin"

pre_configure_target() {
	CEF_DIR="$(get_build_dir _cef)/../../../../cef"
	CEF_VERSION_FILE="$(get_build_dir _cef)/VERSION"
	CEF_VERSION="$(cat ${CEF_VERSION_FILE})"

	export SSL_CERT_FILE=$(get_install_dir openssl)/etc/ssl/cacert.pem.system
	rm -rf ${PKG_BUILD}/subprojects/cef
	ln -s ${CEF_DIR}/cef-${CEF_VERSION}-${ARCH} ${PKG_BUILD}/subprojects/cef
}

pre_make_target() {
	export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
	export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

makeinstall_target() {
    :
}

addon() {
	# create directories
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private/dri
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/data
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/etc
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d

  	# copy cefbrowser
  	cp -Pr ${PKG_BUILD}/.${TARGET_NAME}/Release/* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/
  	cp -Pr ${PKG_BUILD}/.${TARGET_NAME}/cefbrowser ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  	cp -Pr ${PKG_BUILD}/static-content/* ${ADDON_BUILD}/${PKG_ADDON_ID}/data
  	cp -P  ${PKG_BUILD}/config/sockets.ini ${ADDON_BUILD}/${PKG_ADDON_ID}/etc/
  	cp -P  ${PKG_DIR}/_system.d/* ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d

	# set some links
	#(
	#	cd ${ADDON_BUILD}/${PKG_ADDON_ID}/data
	#	mv database database.released
	#	ln -s /storage/cefbrowser/database database
	#)

  	# copy cef-at-spi2-core
  	for i in $(find $(get_build_dir cef-at-spi2-core)/.${TARGET_NAME} -name *.so*) ]; do
		if [ -f $i ]; then
			cp -P $i ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private
		fi
	done

	# TODO: prüfen, ob das richtig ist
	# copy cef-at-spi2-atk
	A=$(get_build_dir cef-at-spi2-atk) || ""
	if [ "$A" != "" ]; then
		for i in $(find $(get_build_dir cef-at-spi2-atk)/.${TARGET_NAME} -name *.so*) ]; do
			if [ -f $i ]; then
				cp -P $i ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private
			fi
		done
		rm ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private/*.symbols || true
	fi

  	# copy mesa
  	cp -Pr $(get_build_dir _mesa)/.${TARGET_NAME}/src/gallium/targets/dri/*.so ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private/dri
  	for i in $(find $(get_build_dir _mesa)/.${TARGET_NAME} -name *.so* ! -path "*/gallium/targets/dri/*"); do
  		if [ -f $i ]; then
  	   		cp -P $i ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private
  	   	fi
  	done

  	# copy atk
  	cp -PL $(get_install_dir atk)/usr/lib/libatk-1.0.so.0 ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy cups
	cp -PL $(get_install_dir cups)/usr/lib/libcups.so.2 ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXft
	cp -PL $(get_install_dir cef-libXft)/usr/lib/libXft.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXrandr
	cp -PL $(get_install_dir cef-libXrandr)/usr/lib/libXrandr.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXcomposite
	cp -PL $(get_install_dir cef-libXcomposite)/usr/lib/libXcomposite.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXcomposite
	cp -PL $(get_install_dir cef-libXdamage)/usr/lib/libXdamage.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXfixes
	cp -PL $(get_install_dir cef-libXfixes)/usr/lib/libXfixes.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXi
	cp -PL $(get_install_dir cef-libXi)/usr/lib/libXi.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libX11
	cp -PL $(get_install_dir cef-libX11)/usr/lib/libX11*.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXext
	cp -PL $(get_install_dir cef-libXext)/usr/lib/libXext.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libxcb
	cp -PL $(get_install_dir cef-libxcb)/usr/lib/libxcb*.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	# copy libXrender
	cp -PL $(get_install_dir cef-libXrender)/usr/lib/libXrender.so* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/private

	rm -f ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/*.symbols || true
}
