#!/bin/bash

declare cmd

# $1 = Distro
# $2 = SubDistro
# $3 = Arch
# $4 = Addon
function create_jq_command_addon_ce {
    eval "cmd=\"[to_entries[] | select(.key | contains(\\\"$1\\\")) | .value.assets[] | select(.name | contains(\\\"$2-$3-$4\\\"))] | sort_by(.createdAt) | reverse | .[0]\""
}

# $1 = Distro
# $2 = Arch
# $3 = Addon
function create_jq_command_addon_le {
    eval "cmd=\"[to_entries[] | select(.key | contains(\\\"$1\\\")) | .value.assets[] | select(.name | contains(\\\"$2-$3\\\"))] | sort_by(.createdAt) | reverse | .[0]\""
}

# $1 = Distro
# $2 = Arch
function create_jq_command_release_le {
    eval "cmd=\"[to_entries[] | select(.key | contains(\\\"$1\\\")) | .value.assets[] | select(.name | contains(\\\"LE-$2\\\")) | select(.name | contains(\\\"sha256\\\") | not)] | sort_by(.createdAt) | reverse | .[0]\""
}

function create_jq_command_release_ce {
    eval "cmd=\"[to_entries[] | select(.key | contains(\\\"$1\\\")) | .value.assets[] | select(.name | contains(\\\"CE-$2\\\")) | select(.name | contains(\\\"sha256\\\") | not)] | sort_by(.createdAt) | reverse | .[0]\""
}

function get_le_arch {
   eval "cmd=\"[ to_entries[] | select(.key | contains(\\\"$1\\\")) | .value.assets[] | .name | match(\\\"LE-(.+?)[.].+VDR.+tar$\\\").captures[0].string ] | sort | unique | .[]\""
}


ALLRELEASES=$(./get_releases.sh)

#
# Addons
#

# CoreELEC-20-ng
create_jq_command_addon_ce CoreELEC-20 ng arm addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_ce CoreELEC-20 ng arm yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-20 ng arm channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-20 ng arm driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.CoreELEC-20-ng.json && rm updates/tmp

# CoreELEC-20-ne
create_jq_command_addon_ce CoreELEC-20 ne aarch64 addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_ce CoreELEC-20 ne aarch64 yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-20 ne aarch64 channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_ce CoreELEC-20 ne aarch64 driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.CoreELEC-20-ne.json && rm updates/tmp

# CoreELEC-21-ng
create_jq_command_addon_ce CoreELEC-21 ng arm addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_ce CoreELEC-21 ng arm yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-21 ng arm channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-21 ng arm driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.CoreELEC-21-ng.json && rm updates/tmp

# CoreELEC-21-ne
create_jq_command_addon_ce CoreELEC-21 ne aarch64 addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_ce CoreELEC-21 ne aarch64 yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-21 ne aarch64 channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_ce CoreELEC-21 ne aarch64 driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.CoreELEC-21-ne.json && rm updates/tmp

# CoreELEC-22-no
create_jq_command_addon_ce CoreELEC-22 no aarch64 addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_ce CoreELEC-22 no aarch64 yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_ce CoreELEC-22 no aarch64 channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_ce CoreELEC-22 no aarch64 driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.CoreELEC-22-no.json && rm updates/tmp

# LibreELEC 12 arm
create_jq_command_addon_le LibreELEC-12 arm addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_le LibreELEC-12 arm yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_le LibreELEC-12 arm channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_le LibreELEC-12 arm driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.LibreELEC-12-arm.json && rm updates/tmp

# LibreELEC 12 aarch64
create_jq_command_addon_le LibreELEC-12 aarch64 addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_le LibreELEC-12 aarch64 yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_le LibreELEC-12 aarch64 channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_le LibreELEC-12 aarch64 driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.LibreELEC-12-aarch64.json && rm updates/tmp

# LibreELEC 13 arm
create_jq_command_addon_le LibreELEC-13 arm addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_le LibreELEC-13 arm yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_le LibreELEC-13 arm channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_le LibreELEC-13 arm driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.LibreELEC-13-arm.json && rm updates/tmp

# LibreELEC 13 aarch64
create_jq_command_addon_le LibreELEC-13 aarch64 addon.cefbrowser && echo $ALLRELEASES | jq "${cmd}" > updates/tmp
create_jq_command_addon_le LibreELEC-13 aarch64 yt-dlp && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
create_jq_command_addon_le LibreELEC-13 aarch64 channellogos && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
#create_jq_command_addon_le LibreELEC-13 aarch64 driver.dvb.dvb-latest && echo $ALLRELEASES | jq "${cmd}" >> updates/tmp
jq -s '.' updates/tmp > updates/addons.LibreELEC-13-aarch64.json && rm updates/tmp

#
# Releases
#
for a in LibreELEC-12 LibreELEC-13; do
    get_le_arch $a
    ARCH=$(echo $ALLRELEASES | jq "${cmd}")

    for i in $ARCH; do
       create_jq_command_release_le "$a" $i
       echo $ALLRELEASES | jq "${cmd}" > updates/release.$a.$(echo $i | sed -e "s#\"##g").json
    done
done

for v in 12 13; do
    create_jq_command_release_le "LibreELEC-Generic" Generic.x86_64-$v
    echo $ALLRELEASES | jq "${cmd}" > updates/release.Generic.$v.json

    create_jq_command_release_le "LibreELEC-Generic" GenericLegacy.x86_64-$v
    echo $ALLRELEASES | jq "${cmd}" > updates/release.GenericLegacy.$v.json
done

for v in 20 21; do
    create_jq_command_release_ce "CoreELEC-$v" Amlogic-ng
    echo $ALLRELEASES | jq "${cmd}" > updates/release.CoreELEC-$v-ng.json

    create_jq_command_release_ce "CoreELEC-$v" Amlogic-ne
    echo $ALLRELEASES | jq "${cmd}" > updates/release.CoreELEC-$v-ne.json
done

create_jq_command_release_ce "CoreELEC-22" Amlogic-no
echo $ALLRELEASES | jq "${cmd}" > updates/release.CoreELEC-22-no.json

cat template-header.html > all-updates.html

for i in $(find updates/*.json); do
   echo "<p><a href=\"$i\">$(basename $i)</a></p>" >> all-updates.html
done
cat  template-body.html >> all-updates.html
