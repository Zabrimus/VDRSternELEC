#!/bin/bash

set -e

sed -i "s/--disable-shared/--enable-shared/" packages/x11/lib/libXxf86vm/package.mk