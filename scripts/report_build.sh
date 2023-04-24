#!/bin/bash

gitCommit=$1
image=$2
digestString=$(docker inspect --format='{{index .RepoDigests 0}}' $image)
digest=${digestString#*:}

artifact=$(jq -n \
    --arg image "$image" \
    --arg commit "$gitCommit" \
    --arg digest "$digest" \
    '{artifact: $image, commit: $commit, digest: $digest}')

echo $artifact > artifacts/$gitCommit.json
