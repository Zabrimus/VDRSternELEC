#!/bin/bash

# Boost package 1.84 in LE Master is currently broken
# The package URL downloads a HTML page instead an archive

set -e

sed -i "s#PKG_VERSION=\"1.84.0\"#PKG_VERSION=\"1.83.0\"#" packages/devel/boost/package.mk
sed -i "s#PKG_SHA256=\"cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454\"#PKG_SHA256=\"6478edfe2f3305127cffe8caf73ea0176c53769f4bf1585be237eb30798c3b8e\"#" packages/devel/boost/package.mk

