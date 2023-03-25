#!/bin/bash

set -e

sed -i -e "s/PKG_VERSION=\"3.1.0\"/PKG_VERSION=\"3.0.8\"/" packages/security/openssl/package.mk
sed -i -e "s/PKG_SHA256=\"aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4\"/PKG_SHA256=\"6c13d2bf38fdf31eac3ce2a347073673f5d63263398f1f69d0df4a41253e4b3e\"/" packages/security/openssl/package.mk
