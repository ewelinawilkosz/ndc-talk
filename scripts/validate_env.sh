#!/bin/bash

lastSnapshot=$(ls -t snapshots/*.json | head -1)

lastSnapshotDigest=$(cat $lastSnapshot | jq '.digest')
lsdClean="${lastSnapshotDigest//\"}"

lastSnapshotImage=$(cat $lastSnapshot | jq '.image')
lsiClean="${lastSnapshotImage//\"}"

echo -e "\nRunning: $lsiClean"
echo -e "Digest: $lsdClean\n"

artifacts=$(ls artifacts/*.json)

for artifact in $artifacts; do
    digest=$(cat $artifact | jq '.digest')
    digestClean="${digest//\"}"
    if [[ $digestClean == $lsdClean ]] ;
    then  
        test=$(cat $artifact | jq '.test')
        testClean="${test//\"}"
        if [[ $testClean == "ok" ]] ;
        then  
            echo Environment status: OK
        else
            echo Environment status: NOT OK
        fi
    fi
done
