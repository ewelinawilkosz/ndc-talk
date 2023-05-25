#!/bin/bash

lastSnapshot=$(ls -t snapshots/*.json | head -1)

lastSnapshotDigest=$(cat $lastSnapshot | jq '.digest')
lsdClean="${lastSnapshotDigest//\"}"

echo $lsdClean

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
            echo Your environment is OK
        else
            echo Your environment is NOT OK
        fi
    fi
done
