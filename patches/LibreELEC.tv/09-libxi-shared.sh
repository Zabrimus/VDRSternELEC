#!/bin/bash

set -e

sed -i "s/--disable-shared/--enable-shared/" packages/x11/lib/libXi/package.mk