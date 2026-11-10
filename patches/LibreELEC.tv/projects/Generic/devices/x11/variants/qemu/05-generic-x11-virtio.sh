#!/bin/bash

set -e

# Build the software renderer additionally to virgl. Since Mesa 25 it's
# softpipe and llvmpipe (needs LLVM), the swrast alias is gone.
grep -q '^ *GALLIUM_DRIVERS+=" virgl"$' config/graphic
sed -i -e 's/GALLIUM_DRIVERS+=" virgl"$/GALLIUM_DRIVERS+=" virgl softpipe"; if [ "${LLVM_SUPPORT}" = "yes" ]; then GALLIUM_DRIVERS+=" llvmpipe"; fi/' config/graphic
