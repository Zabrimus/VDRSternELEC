#!/bin/bash

set -e

sed -i "s#PKG_VERSION=\"2.12.1\"#PKG_VERSION=\"2.11.6\"#" packages/textproc/libxml2/package.mk
sed -i "s#PKG_SHA256=\"8c7e368b1830028f6f4f0e3d128d317f8c49a32e66f4b87ce59a017bdf6514af\"#PKG_SHA256=\"edd54dd02b9a594a2e98ac7842e01253fe39f9a5d9a394139b1e67925cebed01\"#" packages/textproc/libxml2/package.mk
