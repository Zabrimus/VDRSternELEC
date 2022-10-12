#!/bin/bash

set -e

CURRENT_BRANCH=$(git branch --show-current)

# restore version 14.0.6 of llvm package
# Version 15.0.2 fails to compile
if [ "${CURRENT_BRANCH}" = "master" ]; then
  git restore --source=f3038ef9bddfe1ed06f3e315dad9e8959a174bfe packages/lang/llvm
fi

