#!/bin/bash

rm sbom.json

gitCommit=$(git log -1 --format=format:%H)

sbom_file=$(docker sbom --format spdx-json --output sbom.json $1)

sbom_json=$(<sbom.json)

#echo $sbom_json

jq --argjson sbom "$sbom_json" '.sbom = $sbom' artifacts/$gitCommit.json > "tmp" && mv "tmp" artifacts/$gitCommit.json

rm sbom.json
