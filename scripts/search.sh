#!/bin/bash

gitCommit=$1

artifacts=$(ls artifacts/*.json)

check_artifact() {
    echo checking against last snapshot
    lastSnapshot=$(cat "$(ls -t snapshots/*.json | head -1)")
    lastSnapshotDigest=$(jq '.digest' <<< $lastSnapshot)
    lsdClean="${lastSnapshotDigest//\"}"
    if [[ $lsdClean == $1 ]];
    then
        echo "artifact currently running"
    fi
}

for artifact in $artifacts; do
    # from=$(cat $snapshot | jq '.startedAt')
    # imageName=$(cat $snapshot | jq '.image')
    # echo -e Running: "${imageName//\"}" '\t\t' From: $from '\t' Till: $till
    # till=$from

    commit=$(cat $artifact | jq '.commit')
    commitClean="${commit//\"}"

    if [[ $commitClean == $gitCommit* ]] ;
    then
        name=$(cat $artifact | jq '.artifact')
        digest=$(cat $artifact | jq '.digest')
        digestClean="${digest//\"}"
        echo name: "${name//\"}" 
        echo digest: "${digest//\"}"
        check_artifact $digestClean
    fi    
done


