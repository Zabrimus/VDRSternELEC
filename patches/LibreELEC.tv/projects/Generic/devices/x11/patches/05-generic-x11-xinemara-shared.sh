#!/bin/bash

set -e

sed -i "s/--disable-shared/--enable-shared/" packages/x11/lib/libXinerama/package.mk

