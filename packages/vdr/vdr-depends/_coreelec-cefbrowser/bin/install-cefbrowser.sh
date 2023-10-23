#!/bin/bash

# Some configs
ARCH=arm
GITHUB_LATEST_URL=https://github.com/Zabrimus/cefbrowser/releases/latest/download
BROWSER_DIR=/storage/browser
TRANSCODE_DIR=/storage/remotetranscode
TMP_DIR=/storage

# download latest release information
wget ${GITHUB_LATEST_URL}/${ARCH}-current-version.txt -O ${TMP_DIR}/${ARCH}-current-version.txt

# extract latest version
LATEST_CEF_VERSION=`cat ${TMP_DIR}/${ARCH}-current-version.txt | grep CEFVERSION | awk -F= '{ print $2 }'`
LATEST_BROWSER_VERSION=`cat ${TMP_DIR}/${ARCH}-current-version.txt | grep REVISION | awk -F= '{ print $2 }'`

# extract current version
if [ -d ${BROWSER_DIR} ]; then
    CURRENT_CEF_VERSION=`cat ${BROWSER_DIR}/${ARCH}-current-version.txt | grep CEFVERSION | awk -F= '{ print $2 }'`
    CURRENT_BROWSER_VERSION=`cat ${BROWSER_DIR}/${ARCH}-current-version.txt | grep REVISION | awk -F= '{ print $2 }'`
else
    mkdir -p ${BROWSER_DIR}
    CURRENT_CEF_VERSION="x"
    CURRENT_BROWSER_VERSION="x"
fi

# download latest version if necessary
if [ "${CURRENT_CEF_VERSION}" != "${LATEST_CEF_VERSION}" ]; then
    wget -c ${GITHUB_LATEST_URL}/${ARCH}-dist-cefbrowser-cef-${LATEST_CEF_VERSION}.tar.gz -O - | tar -xz -C ${BROWSER_DIR}
fi

if [ "${CURRENT_BROWSER_VERSION}" != "${LATEST_BROWSER_VERSION}" ]; then
    wget -c ${GITHUB_LATEST_URL}/${ARCH}-dist-cefbrowser-exe-${LATEST_BROWSER_VERSION}.tar.gz -O - | tar -xz -C ${BROWSER_DIR}
fi

# update release file
rm -f ${BROWSER_DIR}/${ARCH}-current-version.txt
mv ${TMP_DIR}/${ARCH}-current-version.txt ${BROWSER_DIR}/${ARCH}-current-version.txt

# install remotetranscoder
if [ ! -d TRANSCODE_DIR ]; then
  cd /
      unzip -o /usr/local/config/web-remotetranscode.zip
fi

# install cefbrowser config
if [ ! -f ${BROWSER_DIR}/sockets.ini ]; then
  cd /
      unzip -o /usr/local/config/web-cefbrowser.zip
fi

# copy sockets.ini to config directory
if [ ! -f /storage/.config/vdropt/sockets.ini ]; then
    cp ${BROWSER_DIR}/sockets.ini /storage/.config/vdropt/sockets.ini
fi

systemctl daemon-reload
systemctl enable cefbrowser