#!/bin/bash

if [ -z $VDR_ID ]; then
   VDR_ID=0
fi


if [ $# -lt 2 ]
then
  echo "usage: $0 objectpath interface.method [arguments]"
  exit 1
fi

DEST=de.tvdr.vdr
INTERFACE_DEST="$DEST"

if [[ $VDR_ID -gt  0 ]]; then
   DEST+="${VDR_ID}"
fi;

OBJECT=$1
shift

INTERFACE=$1
shift

dbus-send --system --type=method_call --dest=$DEST --print-reply $OBJECT $INTERFACE_DEST.$INTERFACE "$@"
