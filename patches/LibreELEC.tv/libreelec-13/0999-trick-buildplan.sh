#!/bin/bash

set -e

# The problem is, that these packages only have PKG_DEPENDS_HOST entries,
# therefore these packages have no dependencies in the build plan.
# The build script tries to build these packages as early as possible, but e.g. the compiler is not yet ready
# and therefore the build fails.
#
# These changes add toolchain to the dependencies to try to fix the build plan
sed -i -E "s/^(PKG_DEPENDS_HOST.*)$/\0\nPKG_DEPENDS_TARGET=\"toolchain\"/" packages/graphics/vulkan/glslang/package.mk
sed -i -E "s/^(PKG_DEPENDS_HOST.*)$/\0\nPKG_DEPENDS_TARGET=\"toolchain\"/" packages/graphics/spirv-headers/package.mk
sed -i -E "s/^(PKG_DEPENDS_HOST.*)$/\0\nPKG_DEPENDS_TARGET=\"toolchain\"/" packages/graphics/spirv-tools/package.mk
