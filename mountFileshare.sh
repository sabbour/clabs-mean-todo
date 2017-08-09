#!/bin/bash

while getopts n:k:s: option
do
 case "${option}"
 in
 n) STORAGE_ACCT_NAME=${OPTARG};;
 k) ACCESS_KEY=${OPTARG};;
 s) SHARE_NAME=$OPTARG;;
 esac
done

# Install jq used for the next command
sudo apt-get install jq -y

# Get the IP address of each node using the mesos API and store it inside a file called nodes
curl http://leader.mesos:1050/system/health/v1/nodes | jq '.nodes[].host_ip' | sed 's/\"//g' | sed '/172/d' > nodes

# From the previous file created, run our script to mount our share on each node
cat nodes | while read line
do
  ssh `whoami`@$line -o StrictHostKeyChecking=no < ./cifsMount.sh -n $STORAGE_ACCT_NAME -k $ACCESS_KEY -s $SHARE_NAME
  done