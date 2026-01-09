#!/bin/bash

# get all releases
JSON="{ "
for i in $(gh release list --json tagName | jq ".[].tagName"); do
    A=$(echo $i | sed -e "s#\"##g")
    PART=$(gh release view $A --json assets --jq "[.assets.[] | {name:.name ,url:.url }]")
    JSON="$JSON $i:$PART,"
done
JSON="${JSON::-1} }"

#
# Create addon page
#
ADDONS=""
ADDONS="$ADDONS $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-20")) | {release:.key, value:.value} ]' | ./process-addon.json.pl "CoreELEC-20")"
ADDONS="$ADDONS $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-21")) | {release:.key, value:.value} ]' | ./process-addon.json.pl "CoreELEC-21")"
ADDONS="$ADDONS $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-22")) | {release:.key, value:.value} ]' | ./process-addon.json.pl "CoreELEC-22")"
ADDONS="$ADDONS $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-12")) | {release:.key, value:.value} ]' | ./process-addon.json.pl "LibreELEC-12")"
ADDONS="$ADDONS $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-13")) | {release:.key, value:.value} ]' | ./process-addon.json.pl "LibreELEC-13")"
ADDONS="$ADDONS $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-Generic")) | {release:.key, value:.value} ]' | ./process-addon.json.pl "LibreELEC-Generic")"

cat template-header.html > addons.html
echo $ADDONS >> addons.html
cat  template-body.html >> addons.html

#
# Create releases page
#
RELEASES=""
RELEASES="$RELEASES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-20")) | {release:.key, value:.value} ]' | ./process-release.json.pl "CoreELEC-20")"
RELEASES="$RELEASES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-21")) | {release:.key, value:.value} ]' | ./process-release.json.pl "CoreELEC-21")"
RELEASES="$RELEASES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-22")) | {release:.key, value:.value} ]' | ./process-release.json.pl "CoreELEC-22")"
RELEASES="$RELEASES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-12")) | {release:.key, value:.value} ]' | ./process-release.json.pl "LibreELEC-12")"
RELEASES="$RELEASES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-13")) | {release:.key, value:.value} ]' | ./process-release.json.pl "LibreELEC-13")"
RELEASES="$RELEASES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-Generic")) | {release:.key, value:.value} ]' | ./process-release.json.pl "LibreELEC-Generic")"

cat template-header.html > releases.html
echo $RELEASES >> releases.html
cat  template-body.html >> releases.html

#
# Create images page
#
IMAGES=""
IMAGES="$IMAGES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-20")) | {release:.key, value:.value} ]' | ./process-images.json.pl "CoreELEC-20")"
IMAGES="$IMAGES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-21")) | {release:.key, value:.value} ]' | ./process-images.json.pl "CoreELEC-21")"
IMAGES="$IMAGES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("CoreELEC-22")) | {release:.key, value:.value} ]' | ./process-images.json.pl "CoreELEC-22")"
IMAGES="$IMAGES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-12")) | {release:.key, value:.value} ]' | ./process-images.json.pl "LibreELEC-12")"
IMAGES="$IMAGES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-13")) | {release:.key, value:.value} ]' | ./process-images.json.pl "LibreELEC-13")"
IMAGES="$IMAGES $(echo $JSON | jq '[ to_entries[] | select(.key | contains("LibreELEC-Generic")) | {release:.key, value:.value} ]' | ./process-images.json.pl "LibreELEC-Generic")"

cat template-header.html > images.html
echo $IMAGES >> images.html
cat  template-body.html >> images.html
