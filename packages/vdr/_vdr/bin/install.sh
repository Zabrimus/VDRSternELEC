#!/bin/sh

PROGNAME=$0

PREFIX="/usr/local"
CONF_DIR="${PREFIX}/config"
BIN_DIR="${PREFIX}/bin"

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-i] [-b kodi|vdr] [-T] [-w] [-v] [-c (url)] [-p (url)]

-i       : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
-C       : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
-b kodi  : Kodi will be started after booting
-b vdr   : VDR will be started after booting
-T       : install all necessary files and samples for triggerhappy (A lightweight hotkey daemon)
-w       : install/update web components (remotetranscode, cefbrowser)
-v       : install vtuner-ng (change /storage/.config/start_vtuner.sh accordingly, otherwise is will not start)
-c (url) : install/update cefbrowser binary (located at url or in /storage/.update/addon-cefbrowser.zip)
-p (url) : install/update private configs (located at url or within /storage/.update)
-l (url) : install/update channel logos (located at url or in /storage/.update/channellogos.tar.gz)
EOF
  exit 1
}

install() {
  # delete old sample configuration if it exists and extract the new one
  rm -Rf /storage/.config/vdropt-sample
  rm -Rf /storage/cefbrowser-sample

  cd /
  for i in `ls ${CONF_DIR}/*-sample-config.zip`; do
     unzip -o $i
  done

  for i in `ls ${CONF_DIR}/*-sample.zip`; do
     unzip -o $i
  done

  # copy samples to final directory
  if [ ! -d /storage/.config/vdropt ]; then
    cp -a /storage/.config/vdropt-sample /storage/.config/vdropt
  fi

  # copy cefbrowser files to final directory
  if [ ! -d /storage/cefbrowser ]; then
    cp -a /storage/cefbrowser-sample /storage/cefbrowser
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
  systemctl disable switch_kodi_vdr.path
  systemctl disable switch_kodi_vdr.service
  systemctl disable vdropt.service
  systemctl disable vdropt.target

  # copy sysctl.d files
  for i in `ls /usr/local/sysctl.d/*`; do
     FILENAME=$(basename $i)
     if [ ! -e /storage/.config/sysctl.d/${FILENAME} ]; then
        cp -a /usr/local/sysctl.d/${FILENAME} /storage/.config/sysctl.d/${FILENAME}
     fi
  done

  # create autostart.sh if it does not exists
  if [ ! -f /storage/.config/autostart.sh ]; then
cat > /storage/.config/autostart.sh<< EOF
#!/bin/sh
/usr/local/bin/autostart.sh
EOF

  chmod +x /storage/.config/autostart.sh
  else
      echo "/storage/.config/autostart.sh already exists."
      echo "Please insert '/storage/.opt/vdr/bin/autostart.sh' manually into this file (without quotes)."
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

install_web() {
  if [ ! -f "/storage/browser/addon.cefbrowser/bin/cefbrowser" ]; then
    echo "cefbrowser is missing, install cefbrowser first!"
    echo "   -> install.sh -c [url]"
    exit 1
  fi

  # copy data directory
  if [ ! -d /storage/browser/database ]; then
      mkdir -p /storage/browser/database
      cp -a /storage/browser/addon.cefbrowser/data/database /storage/browser

      # copy possibly existing database files
      if [ -d /storage/cefbrowser/data/database ]; then
         cp -a /storage/cefbrowser/data/database/* /storage/browser/database
      fi
  fi

  # copy system.d files
  mkdir -p /storage/.config/system.d

  # copy system.d units
  cp /storage/browser/addon.cefbrowser/system.d/cefbrowser.service /storage/.config/system.d/cefbrowser.service
  cp /usr/local/system.d/remotetranscode.service /storage/.config/system.d

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

  if [ ! -f /storage/.config/system.d/vtuner-ng.service ]; then
      cp -a /usr/local/system.d/vtuner-ng.service /storage/.config/system.d/vtuner-ng.service

      systemctl daemon-reload
      systemctl enable vtuner-ng.service
  fi

  echo "Info:"
  echo "  Please check and adapt the script /storage/.config/start_vtuner.sh accordingly."
  echo "  Otherwise vtuner-ng will not work as expected."
}

install_cefbrowser() {
  rm -Rf /storage/tmp
  mkdir /storage/tmp
  mkdir -p /storage/browser
  cd /storage/tmp

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download cefbrowser from $1"
    if wget -q "$1" -O addon-cefbrowser.zip; then
      sync
      echo "$1 saved to /storage/tmp"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/addon-cefbrowser.zip
  elif [ -e "/storage/.update/addon-cefbrowser.zip" ]; then
    echo "Move /storage/.update/addon-cefbrowser.zip"
    mv "/storage/.update/addon-cefbrowser.zip" "/storage/tmp/addon-cefbrowser.zip"
  else
    echo "No addon-cefbrowser file found, exiting"
    exit 1
  fi

  # unzip addon-cefbrowser.zip
  if [ -e "/storage/tmp/addon-cefbrowser.zip" ]; then
    cd /storage/browser
    echo "Unzip addon-cefbrowser.zip"
    unzip -o "/storage/tmp/addon-cefbrowser.zip"
  else
    echo "No addon-cefbrowser zip found, exiting"
    exit 1
  fi
}

install_channellogos() {
  rm -Rf /storage/tmp
  mkdir /storage/tmp
  cd /storage/tmp

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download channellogos from $1"
    if wget -q "$1" -O channellogos.tar.gz; then
      sync
      echo "$1 saved to /storage/tmp"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/channellogos.tar.gz
  elif [ -e "/storage/.update/channellogos.tar.gz" ]; then
    echo "Move /storage/.update/channellogos.tar.gz"
    mv "/storage/.update/channellogos.tar.gz" "/storage/tmp/channellogos.tar.gz"
  else
    echo "No channellogos file found, exiting"
    exit 1
  fi

  # unzip channellogos.tar.gz
  if [ -e "/storage/tmp/channellogos.tar.gz" ]; then
    cd /storage
    echo "Unzip channellogos.tar.gz"
    tar -xf "/storage/tmp/channellogos.tar.gz"
  else
    echo "No channellogos tar.gz found, exiting"
    exit 1
  fi
}

install_private() {
  rm -Rf /storage/tmp
  mkdir /storage/tmp
  cd /storage/tmp

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download private confs from $1"
    if wget -q "$1" -O ve-private-conf.zip; then
      sync
      echo "$1 saved to /storage/tmp"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/ve-private-conf.zip
  elif [ -e "/storage/.update/ve-private-conf.zip" ]; then
    echo "Move /storage/.update/ve-private-conf.zip"
    mv "/storage/.update/ve-private-conf.zip" "/storage/tmp/ve-private-conf.zip"
  else
    echo "No private conf file found, exiting"
    exit 1
  fi

  # unzip ve-private-conf.tar.bz2
  if [ -e "/storage/tmp/ve-private-conf.zip" ]; then
    cd /
    echo "Unzip cef.zip"
    unzip -o "/storage/tmp/ve-private-conf.zip"
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
  else
      echo "Unknown Boot parameter"
      exit 1
  fi
}

if [ "$#" = "0" ]; then
    usage
fi

while getopts b:iTCwvcp: o; do
  case $o in
    (i) install;;
    (C) install_copy;;
    (b) boot "$OPTARG";;
    (T) install_triggerhappy;;
    (w) install_web;;
    (v) install_vtuner;;
    (c) eval url=\${$(( $OPTIND ))}
        if [ -n $url ]; then
          install_cefbrowser "$url"
        else
          install_cefbrowser
        fi
        ;;
    (p) eval url=\${$(( $OPTIND -1 ))}
        if [ -n $url ]; then
          install_private "$url"
        else
          install_private
        fi
        ;;
    (l) eval url=\${$(( $OPTIND ))}
        if [ -n $url ]; then
          install_channellogos "$url"
        else
          install_channellogos
        fi
        ;;
    (*) usage
  esac
done

# create default directories
mkdir -p /storage/.cache/vdr/markad
