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
rm $FILENAME.ovf
rm $FILENAME.vmdk

# build (add extras if desired):
# ./build.sh -config LibreELEC-12-x86_64-x11-qemu

# content of metadata.yaml:
# -------------------------
# architecture: x86_64
# creation_date: 1701385200
# properties:
#   description: LibreELEC 12
#   os: LE
#   release: 12

# create tar
# ----------
# tar cf metadata.tar metadata.yaml

# import image:
# -------------
# incus image import metadata.tar <filename>.qcow2 --alias LE12

# create vm:
# incus create LE12 libreelec --vm -c security.secureboot=false -c limits.cpu=2 -c limits.memory=4GiB

# start vm:
# incus start libreelec --console=vga

# Connect to vga console
# incus console libreelec --type vga

# Possible problems:
# ------------------
# if this message appears
# incus create LE12 libreelec --vm -c security.secureboot=false -c limits.cpu=2 -c limits.memory=4GiB
# Creating libreelec
# Error: Failed creating instance record: Failed initialising instance: Invalid config: No uid/gid allocation configured. In this mode, only privileged containers are supported
#
# both files /etc/subgid and /etc/subuid needs this entry (and a reboot is necessary)
# root:1000000:65536