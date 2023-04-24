#!/bin/bash 

timestamp=$(date +%s)

podName=$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}')
namespaceName=$(kubectl get pods -o=jsonpath='{.items[0].metadata.namespace}')            
imageName=$(kubectl get pods -o=jsonpath='{.items[0].spec.containers[0].image}')
startedAt=$(kubectl get pods -o=jsonpath='{.items[0].status.containerStatuses[0].state.*.startedAt}')

echo Namespace: $namespaceName, Pod: $podName
echo "##############################################"
echo Image: $imageName
echo StartedAt: $startedAt

snapshot=$(jq -n \
    --arg namespace "$namespaceName" \
    --arg pod "$podName" \
    --arg image "$imageName" \
    --arg startedAt "$startedAt" \
    --arg status "running" \
    '{namespace: $namespace, pod: $pod, image: $image, startedAt: $startedAt, status: $status}')


echo read old file
lastSnapshot=$(cat $(ls -t *.json | head -1))
echo $lastSnapshot
echo create and read new file
echo $snapshot > $timestamp.json
newSnapshot=$(cat $timestamp.json)
echo $newSnapshot


if [ "$lastSnapshot" == "$newSnapshot" ]; then
    echo No need to keep new snapshot!
    rm $timestamp.json
else   
    echo Keeping new snapshot...
fi
