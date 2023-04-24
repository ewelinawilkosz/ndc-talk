#!/bin/bash

snapshots=$(ls -t snapshots/*.json)
echo
echo "-------------------------------------------"
echo Environment changelog:
echo "-------------------------------------------"
echo 

till="now"

for snapshot in $snapshots; do
    from=$(cat $snapshot | jq '.startedAt')
    imageName=$(cat $snapshot | jq '.image')
    echo -e Running: "${imageName//\"}" '\t\t' From: $from '\t' Till: $till
    till=$from
done