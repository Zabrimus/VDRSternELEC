#!/bin/bash

set -e

# restore version 3.81 of nss package
git restore --source=6dbd9f42733418e1b80e270a54ed7c327d9898b6 packages/security/nss/package.mk
