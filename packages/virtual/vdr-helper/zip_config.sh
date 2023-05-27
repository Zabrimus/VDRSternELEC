#!/bin/bash

INSTALL=$1
PKG_DIR=$2
PLUGIN=$3
APIVERSION=$4

# create default ${PLUGIN}.conf // will be overwritten, if we have something in the plugin directory
mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d/
cat > ${INSTALL}/storage/.config/vdropt-sample/conf.d/${PLUGIN}.conf <<EOF
[${PLUGIN}]

EOF

# create default ${PLUGIN}_settings.ini // will be overwritten, if we have something in the plugin directory
cat > ${INSTALL}/storage/.config/vdropt-sample/conf.d/${PLUGIN}_settings.ini <<EOF
[EasyPluginManager]
AutoRun = false
Stop = true
Args =

EOF

# hack: streamdev names its confs streamdev-server/client.conf, so remove the defaults again
if [ ${PLUGIN} = "streamdev" ]; then
  rm ${INSTALL}/storage/.config/vdropt-sample/conf.d/${PLUGIN}.conf
  rm ${INSTALL}/storage/.config/vdropt-sample/conf.d/${PLUGIN}_settings.ini
fi

# copy plugin conf.d/* to sample config dir
cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/ 2>/dev/null

if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
  cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
  rm -Rf ${INSTALL}/storage/.config/vdropt
 fi

# create links for libs
if [ -n "$APIVERSION" ]; then
  mkdir -p ${INSTALL}/storage/.config/vdrlibs/save
  mv ${INSTALL}/usr/local/lib/vdr/libvdr-${PLUGIN}.so.${APIVERSION} ${INSTALL}/storage/.config/vdrlibs/save/libvdr-${PLUGIN}.so.${APIVERSION}
  ln -s /storage/.config/vdrlibs/libvdr-${PLUGIN}.so.${APIVERSION} ${INSTALL}/usr/local/lib/vdr/libvdr-${PLUGIN}.so.${APIVERSION}
  ln -s /storage/.config/vdrlibs/save/libvdr-${PLUGIN}.so.${APIVERSION} ${INSTALL}/storage/.config/vdrlibs/libvdr-${PLUGIN}.so.${APIVERSION}
fi

# create config.zip
cd ${INSTALL}
mkdir -p ${INSTALL}/usr/local/config/
zip -yqrum9 "${INSTALL}/usr/local/config/${PLUGIN}-sample-config.zip" storage
