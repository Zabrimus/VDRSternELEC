# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="kodi-addons"
PKG_VERSION=""
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="kodi"
PKG_SECTION="virtual"
PKG_LONGDESC="Preinstall kodi addons"

post_install() {
  mkdir -p $INSTALL/usr/share/kodi/storage_addons

  for i in $(ls ${TARGET_IMG}/${ADDONS}/${ADDON_VERSION}/${DEVICE}/${TARGET_ARCH}); do
	cp ${TARGET_IMG}/${ADDONS}/${ADDON_VERSION}/${DEVICE}/${TARGET_ARCH}/$i/*.zip $INSTALL/usr/share/kodi/storage_addons

  	# update addon manifest / enable addon in Kodi
  	ADDON_MANIFEST=$INSTALL/usr/share/kodi/system/addon-manifest.xml
  	xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "$i" $ADDON_MANIFEST
  done

  mkdir -p $INSTALL/usr/local/bin
  cp -PR $PKG_DIR/scripts/* $INSTALL/usr/local/bin

  enable_service storage-addons-copy.service
}