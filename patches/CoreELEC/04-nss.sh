#!/bin/bash

set -e

CURRENT_BRANCH=$(git branch --show-current)

# restore version 3.81 of nss package
if [ "${CURRENT_BRANCH}" = "coreelec-20" ]; then
  git restore --source=6dbd9f42733418e1b80e270a54ed7c327d9898b6 packages/security/nss/package.mk
fi
