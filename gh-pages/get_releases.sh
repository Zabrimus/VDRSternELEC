#!/bin/bash

JSON="{ "
for i in $(gh release list --json tagName | jq ".[].tagName"); do
    A=$(echo $i | sed -e "s#\"##g")
    # PART=$(gh release view $A --json assets --jq "[.assets.[] | {name:.name ,url:.url }]")
    PART=$(gh release view $A --json assets)
    JSON="$JSON $i:$PART,"
done
JSON="${JSON::-1} }"

echo "$JSON"