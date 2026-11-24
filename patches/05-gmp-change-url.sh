#!/bin/bash

set -e

sed -i "s#https://gmplib.org/download/gmp/#https://ftp.gnu.org/gnu/gmp/#" packages/devel/gmp/package.mk

# only a workaround for the download, not fatal
if ! grep -q "https://ftp.gnu.org/gnu/gmp/" packages/devel/gmp/package.mk; then
  echo "WARNING: $0: URL of gmp not changed"
fi
