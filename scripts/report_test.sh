#!/bin/bash

gitCommit=$(git log -1 --format=format:%H)
result=$1

jq --arg test "$result" '.test = $test' artifacts/$gitCommit.json > "tmp" && mv "tmp" artifacts/$gitCommit.json
