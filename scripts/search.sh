#!/bin/bash

gitCommit=$1



check_artifact() {
    lastSnapshotFile=$(ls -t snapshots/*.json | head -1)
    lastSnapshot=$(cat "$lastSnapshotFile")
    lastSnapshotDigest=$(jq '.digest' <<< $lastSnapshot)
    lsdClean="${lastSnapshotDigest//\"}"
    from=$(cat $lastSnapshotFile | jq '.startedAt')
    if [[ $lsdClean == $1 ]];
    then
        echo Running now: YES
        echo -e '\t'$(./list-env.sh | grep "From: ${from//\"}")
    else    
        echo Running now: NO
    fi

    snapshots=$(ls snapshots/*.json)
    for snapshot in $snapshots; do
        if [[ $snapshot == $lastSnapshotFile ]]; then
            continue
        fi
        digest=$(cat $snapshot | jq '.digest')
        digestClean="${digest//\"}"
        from=$(cat $snapshot | jq '.startedAt')
        if [[ $digestClean == $1 ]];
        then
            echo Running previously: YES 
            # echo -e '\tstarted at: '$from
            echo -e '\t'$(./list-env.sh | grep "From: ${from//\"}")
        fi
    done

}


artifacts=$(ls artifacts/*.json)
for artifact in $artifacts; do
    # from=$(cat $snapshot | jq '.startedAt')
    # imageName=$(cat $snapshot | jq '.image')
    # echo -e Running: "${imageName//\"}" '\t\t' From: $from '\t' Till: $till
    # till=$from

    commit=$(cat $artifact | jq '.commit')
    commitClean="${commit//\"}"

    if [[ $commitClean == $gitCommit* ]] ;
    then
        echo ""
        name=$(cat $artifact | jq '.artifact')
        digest=$(cat $artifact | jq '.digest')
        digestClean="${digest//\"}"
        echo name: "${name//\"}" 
        echo digest: "${digest//\"}"
        echo ""
        check_artifact $digestClean
    fi    
done

echo ""
