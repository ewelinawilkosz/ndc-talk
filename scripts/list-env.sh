#!/bin/bash

snapshots=$(ls -t snapshots/*.json)
echo
echo "------------------------------------------"
echo Environment changelog:
echo "------------------------------------------"
echo 

till="now"

for snapshot in $snapshots; do
    from=$(cat $snapshot | jq '.startedAt')
    imageName=$(cat $snapshot | jq '.image')
    printf 'From: %s\tTill: %-25s %s\n' "${from//\"}" "${till//\"}" "${imageName//\"}"
    till=$from
done