#!/bin/bash

#probably a bug in Kernel 5.15: the last shown OSD comes back and keeps visible
#after exiting vdr oder kodi. Let's flash the OSD manually:

kernel="$(uname -r)"
major=$(echo "$kernel" | cut -d. -f1)
minor="${kernel#*.}"
minor="${minor%%.*}"
if  [ "$major.$minor" = "5.15" ]; then
   echo 1 > /sys/class/graphics/fb0/blank || true
   echo 1 > /sys/class/graphics/fb0/force_free_mem || true
   echo 0 > /sys/class/graphics/fb0/force_free_mem || true
   echo 0 > /sys/class/graphics/fb0/blank || true
fi
