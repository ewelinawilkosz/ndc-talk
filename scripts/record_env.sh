#!/bin/bash 
timestamp=$(date +%s)

podName=$(/usr/local/bin/kubectl get pods -o=jsonpath='{.items[0].metadata.name}')
namespaceName=$(/usr/local/bin/kubectl get pods -o=jsonpath='{.items[0].metadata.namespace}')            
imageName=$(/usr/local/bin/kubectl get pods -o=jsonpath='{.items[0].spec.containers[0].image}')
startedAt=$(/usr/local/bin/kubectl get pods -o=jsonpath='{.items[0].status.containerStatuses[0].state.*.startedAt}')
imageID=$(/usr/local/bin/kubectl get pods -o=jsonpath='{.items[0].status.containerStatuses[0].imageID}')

digest=$(awk -F'sha256:' '{print $2}' <<< "$imageID")

echo Namespace: $namespaceName, Pod: $podName
echo "##############################################"
echo Image: $imageName
echo Digest: $digest
echo StartedAt: $startedAt

snapshot=$(/opt/homebrew/bin/jq -n \
    --arg namespace "$namespaceName" \
    --arg pod "$podName" \
    --arg image "$imageName" \
    --arg startedAt "$startedAt" \
    --arg status "running" \
    --arg digest "$digest" \
    '{namespace: $namespace, pod: $pod, image: $image, startedAt: $startedAt, status: $status, digest: $digest}')

lastSnapshot=""
echo read old file
lastSnapshot=$(cat "$(ls -t snapshots/*.json | head -1)")
echo $lastSnapshot
echo create and read new file
echo $snapshot > snapshots/$timestamp.json
newSnapshot=$(cat snapshots/$timestamp.json)
echo $newSnapshot


if [ "$lastSnapshot" == "$newSnapshot" ]; then
    echo No need to keep new snapshot!
    rm snapshots/$timestamp.json
else   
    echo Keeping new snapshot...
fi
