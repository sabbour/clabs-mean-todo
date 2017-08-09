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

# Install the cifs utils, should be already installed
sudo apt-get update && sudo apt-get -y install cifs-utils

# Create the local folder that will contain our share
if [ ! -d "/mnt/share/$SHARE_NAME" ]; then sudo mkdir -p "/mnt/share/$SHARE_NAME" ; fi

# Mount the share under the previous local folder created
sudo mount -t cifs //$STORAGE_ACCT_NAME.file.core.windows.net/$SHARE_NAME /mnt/share/$SHARE_NAME -o vers=3.0,username=$STORAGE_ACCT_NAME,password=$ACCESS_KEY,dir_mode=0777,file_mode=0777