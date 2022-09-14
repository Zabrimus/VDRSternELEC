#!/bin/bash

set -e

sed -i "s/OPENGLES=\"no\"/OPENGLES=\"mesa\"/" projects/Generic/devices/x11/options