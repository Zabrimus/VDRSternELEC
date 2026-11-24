#!/bin/sh

PROGNAME=$0

PREFIX="/usr/local"
CONF_DIR="${PREFIX}/config"
BIN_DIR="${PREFIX}/bin"
# downloads, deleted and created again by each install_* function
TMP_DIR="/storage/.cache/install.tmp"

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-i] [-C] [-b kodi|vdr] [-T] [-w] [-v] [-c (url)] [-R (url)] [-p (url)] [-l (url)]

-i       : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
-C       : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
-b kodi  : Kodi will be started after booting
-b vdr   : VDR will be started after booting
-T       : install all necessary files and samples for triggerhappy (A lightweight hotkey daemon)
-w       : install/update web components (remotetranscode, cefbrowser)
-v       : install vtuner-ng (change /storage/.config/start_vtuner.sh accordingly, otherwise it will not start)
-c (url) : install/update cefbrowser binary (located at url or in /storage/.update/addon-cefbrowser.zip)
-R (url) : install/update CEF runtime for cefbrowser (located at url or in /storage/.update/addon-cefruntime.zip)
-p (url) : install/update private configs (located at url or in /storage/.update/ve-private-conf.zip)
-l (url) : install/update channel logos (located at url or in /storage/.update/channellogos.tar.gz)
EOF
  exit 1
}

install() {
  # delete old sample configuration if it exists and extract the new one
  rm -Rf /storage/.config/vdropt-sample

  cd /
  for i in `ls ${CONF_DIR}/*-sample-config.zip`; do
     unzip -o $i
  done

  # copy samples to final directory
  if [ ! -d /storage/.config/vdropt ]; then
    cp -a /storage/.config/vdropt-sample /storage/.config/vdropt
  fi

  for i in `ls /usr/local/system.d/*`; do
     FILENAME=$(basename $i)
     if [ ! -e /storage/.config/system.d/${FILENAME} ]; then
        cp -a /usr/local/system.d/${FILENAME} /storage/.config/system.d/${FILENAME}
     fi
  done

  systemctl daemon-reload

  # disable some services. This is important and shall not be changed!
  # use a whitelist
  systemctl disable switch_kodi_vdr.service
  systemctl disable vdropt.service
  systemctl disable vdropt.target

  # enable some services
  systemctl enable switch_kodi_vdr.path
  systemctl start switch_kodi_vdr.path

  systemctl enable VDRCoreELEC.service
  systemctl start VDRCoreELEC.service

  # copy sysctl.d files
  for i in `ls /usr/local/sysctl.d/*`; do
     FILENAME=$(basename $i)
     if [ ! -e /storage/.config/sysctl.d/${FILENAME} ]; then
        cp -a /usr/local/sysctl.d/${FILENAME} /storage/.config/sysctl.d/${FILENAME}
     fi
  done

  if [ -f /storage/.config/autostart.sh ]; then
      sed -i -e 's#/storage/.opt/vdr/bin/autostart.sh##' /storage/.config/autostart.sh
  fi

  # copy default skin and add VDR menu entry in the power menu
  if [ ! -d  /storage/.kodi/addons/skin.estuary ]; then
      cp -a /usr/share/kodi/addons/skin.estuary /storage/.kodi/addons
      cp ${CONF_DIR}/DialogButtonMenu.xml /storage/.kodi/addons/skin.estuary/xml
  else
      echo "Skin already exists. Modification of DialogButtonMenu.xml will not be copied."
      echo "Please add VDR entry manually. Sample: ${CONF_DIR}/DialogButtonMenu.xml"
  fi
}

install_triggerhappy() {
  # create all directories if they currently not exists
  mkdir -p /storage/.config/system.d
  mkdir -p /storage/.config/udev.rules.d
  mkdir -p /storage/.config/triggers.d

  # copy files
  cp /usr/local/config/triggerhappy/system.d/* /storage/.config/system.d
  cp /usr/local/config/triggerhappy/udev.rules.d/* /storage/.config/udev.rules.d
  cp /usr/local/config/triggerhappy/triggers.d/* /storage/.config/triggers.d

  systemctl daemon-reload

  systemctl enable triggerhappy.socket
  systemctl enable triggerhappy.service

  systemctl start triggerhappy.socket
  systemctl start triggerhappy.service
}

# Install the systemd unit $1 into /storage/.config/system.d. A different
# existing unit is saved as <unit>.bak before. Own changes belong into a
# drop-in /storage/.config/system.d/<unit>.d/*.conf, which is never touched.
install_unit() {
  dest="/storage/.config/system.d/$(basename "$1")"

  mkdir -p /storage/.config/system.d
  if [ -f "$dest" ] && ! cmp -s "$1" "$dest"; then
    cp -a "$dest" "$dest.bak"
    echo "$dest has been updated, the previous version is saved as $dest.bak"
    echo "   Own changes are kept on updates in $dest.d/override.conf"
  fi
  cp "$1" "$dest"
}

install_web() {
  if [ ! -f "/storage/browser/addon.cefbrowser/bin/cefbrowser" ]; then
    echo "cefbrowser is missing, install cefbrowser first!"
    echo "   -> install.sh -c [url]"
    exit 1
  fi

  check_cefruntime || exit 1

  # copy data directory
  if [ ! -d /storage/browser/database ]; then
      mkdir -p /storage/browser/database
      cp -a /storage/browser/addon.cefbrowser/data/database /storage/browser

      # copy possibly existing database files
      if [ -d /storage/cefbrowser/data/database ]; then
         cp -a /storage/cefbrowser/data/database/* /storage/browser/database
      fi
  fi

  # install system.d units
  install_unit /storage/browser/addon.cefbrowser/system.d/cefbrowser.service
  install_unit /usr/local/system.d/remotetranscode.service

  systemctl daemon-reload
  systemctl enable cefbrowser.service
  systemctl enable remotetranscode.service
}

install_vtuner() {
  if [ ! -f /storage/.config/start_vtuner.sh ]; then
      cp -a /usr/local/bin/sample_start_vtuner.sh /storage/.config/start_vtuner.sh
  fi

  if [ ! -f /storage/.config/stop_vtuner.sh ]; then
      cp -a /usr/local/bin/stop_vtuner.sh /storage/.config/stop_vtuner.sh
  fi

  # -i copies the unit already, so enable it in any case
  if [ ! -f /storage/.config/system.d/vtuner-ng.service ]; then
      cp -a /usr/local/system.d/vtuner-ng.service /storage/.config/system.d/vtuner-ng.service
  fi

  systemctl daemon-reload
  systemctl enable vtuner-ng.service

  echo "Info:"
  echo "  Please check and adapt the script /storage/.config/start_vtuner.sh accordingly."
  echo "  Otherwise vtuner-ng will not work as expected."
}

# cefbrowser needs the CEF runtime of the version it has been built with.
# The link addon.cefbrowser/cef points to it, the service uses only the link.
check_cefruntime() {
  if [ ! -f /storage/browser/addon.cefbrowser/etc/cef-version ]; then
    # no cefbrowser yet, or an older one with included runtime
    return 0
  fi

  CEF_VERSION="$(cat /storage/browser/addon.cefbrowser/etc/cef-version)"
  ln -sfn "../addon.cefruntime/${CEF_VERSION}" /storage/browser/addon.cefbrowser/cef

  if [ ! -f "/storage/browser/addon.cefruntime/${CEF_VERSION}/lib/libcef.so" ]; then
    echo "CEF runtime ${CEF_VERSION} is missing, install it first!"
    echo "   -> install.sh -R [url]"
    return 1
  fi

  return 0
}

install_cefruntime() {
  rm -Rf "${TMP_DIR}"
  mkdir -p "${TMP_DIR}"
  mkdir -p /storage/browser
  cd "${TMP_DIR}"

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download cefruntime from $1"
    if wget -q "$1" -O addon-cefruntime.zip; then
      sync
      echo "$1 saved to ${TMP_DIR}"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/addon-cefruntime.zip
  elif [ -e "/storage/.update/addon-cefruntime.zip" ]; then
    echo "Move /storage/.update/addon-cefruntime.zip"
    mv "/storage/.update/addon-cefruntime.zip" "${TMP_DIR}/addon-cefruntime.zip"
  else
    echo "No addon-cefruntime file found, exiting"
    exit 1
  fi

  # unzip addon-cefruntime.zip, each CEF version has its own directory
  cd /storage/browser
  echo "Unzip addon-cefruntime.zip"
  unzip -o "${TMP_DIR}/addon-cefruntime.zip"

  check_cefruntime
}

install_cefbrowser() {
  rm -Rf "${TMP_DIR}"
  mkdir -p "${TMP_DIR}"
  mkdir -p /storage/browser
  cd "${TMP_DIR}"

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download cefbrowser from $1"
    if wget -q "$1" -O addon-cefbrowser.zip; then
      sync
      echo "$1 saved to ${TMP_DIR}"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/addon-cefbrowser.zip
  elif [ -e "/storage/.update/addon-cefbrowser.zip" ]; then
    echo "Move /storage/.update/addon-cefbrowser.zip"
    mv "/storage/.update/addon-cefbrowser.zip" "${TMP_DIR}/addon-cefbrowser.zip"
  else
    echo "No addon-cefbrowser file found, exiting"
    exit 1
  fi

  # unzip addon-cefbrowser.zip
  if [ -e "${TMP_DIR}/addon-cefbrowser.zip" ]; then
    cd /storage/browser
    echo "Unzip addon-cefbrowser.zip"
    unzip -o "${TMP_DIR}/addon-cefbrowser.zip"
  else
    echo "No addon-cefbrowser zip found, exiting"
    exit 1
  fi

  # the old runtime inside the addon is not used anymore
  if [ -f /storage/browser/addon.cefbrowser/etc/cef-version ]; then
    rm -Rf /storage/browser/addon.cefbrowser/lib
  fi

  # keep an installed service up to date with the new cefbrowser
  if [ -f /storage/.config/system.d/cefbrowser.service ]; then
    install_unit /storage/browser/addon.cefbrowser/system.d/cefbrowser.service
    systemctl daemon-reload
  fi

  check_cefruntime
}

install_channellogos() {
  rm -Rf "${TMP_DIR}"
  mkdir -p "${TMP_DIR}"
  cd "${TMP_DIR}"

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download channellogos from $1"
    if wget -q "$1" -O channellogos.tar.gz; then
      sync
      echo "$1 saved to ${TMP_DIR}"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/channellogos.tar.gz
  elif [ -e "/storage/.update/channellogos.tar.gz" ]; then
    echo "Move /storage/.update/channellogos.tar.gz"
    mv "/storage/.update/channellogos.tar.gz" "${TMP_DIR}/channellogos.tar.gz"
  else
    echo "No channellogos file found, exiting"
    exit 1
  fi

  # unzip channellogos.tar.gz
  if [ -e "${TMP_DIR}/channellogos.tar.gz" ]; then
    cd /storage
    echo "Unzip channellogos.tar.gz"
    tar -xf "${TMP_DIR}/channellogos.tar.gz"
  else
    echo "No channellogos tar.gz found, exiting"
    exit 1
  fi
}

install_private() {
  rm -Rf "${TMP_DIR}"
  mkdir -p "${TMP_DIR}"
  cd "${TMP_DIR}"

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download private confs from $1"
    if wget -q "$1" -O ve-private-conf.zip; then
      sync
      echo "$1 saved to ${TMP_DIR}"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/ve-private-conf.zip
  elif [ -e "/storage/.update/ve-private-conf.zip" ]; then
    echo "Move /storage/.update/ve-private-conf.zip"
    mv "/storage/.update/ve-private-conf.zip" "${TMP_DIR}/ve-private-conf.zip"
  else
    echo "No private conf file found, exiting"
    exit 1
  fi

  # unzip ve-private-conf.zip
  if [ -e "${TMP_DIR}/ve-private-conf.zip" ]; then
    cd /
    echo "Unzip ve-private-conf.zip"
    unzip -o "${TMP_DIR}/ve-private-conf.zip"
  else
    echo "No private conf zip found, exiting"
    exit 1
  fi
}

install_copy() {
  install

  cp -a /storage/.config/vdropt/* /storage/.config/vdropt-sample/
  cp -a /storage/.config/vdropt-sample/* /storage/.config/vdropt/
}


boot() {
  if [ "$1" = "kodi" ]; then
      echo "Boot Kodi"

      if [ -f /storage/.profile ]; then
          sed -i -e "/^START_PRG.*$/d" /storage/.profile
      fi
      echo "START_PRG=kodi" >> /storage/.profile
  elif [ "$1" = "vdr" ]; then
      echo "Boot VDR"

      if [ -f /storage/.profile ]; then
          sed -i -e "/^START_PRG.*$/d" /storage/.profile
      fi
      echo "START_PRG=vdr" >> /storage/.profile

      systemctl daemon-reload
      systemctl enable setup_bl301
  else
      echo "Unknown Boot parameter"
      exit 1
  fi
}

if [ "$#" = "0" ]; then
    usage
fi

# Options are handled in the given order. The url of -c, -R, -p and -l is
# optional, an argument starting with "-" is the next option.
while [ "$#" -gt 0 ]; do
  case $1 in
    -i) install;;
    -C) install_copy;;
    -b) shift
        boot "$1";;
    -T) install_triggerhappy;;
    -w) install_web;;
    -v) install_vtuner;;
    -c|-R|-p|-l)
        opt=$1
        url=""
        case $2 in
          ""|-*) ;;
          *) url=$2
             shift;;
        esac
        case $opt in
          -c) install_cefbrowser "$url";;
          -R) install_cefruntime "$url";;
          -p) install_private "$url";;
          -l) install_channellogos "$url";;
        esac
        ;;
    *) usage;;
  esac
  shift
done

# create default directories
mkdir -p /storage/.cache/vdr/markad
