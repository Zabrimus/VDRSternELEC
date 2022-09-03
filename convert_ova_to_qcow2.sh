#!/bin/bash

set -e

if [[ "$#" -eq 0 ]]; then
      cat << EOF >&2
Usage: $0 <file>
EOF
fi

tar -xf $1

FILENAME=$(basename $1 .ova)

qemu-img convert -f vmdk -O qcow2 $FILENAME.vmdk $FILENAME.qcow2
qemu-img resize $FILENAME.qcow2 +5G
