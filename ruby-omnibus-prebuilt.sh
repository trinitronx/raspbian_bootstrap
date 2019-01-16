#!/bin/bash

if [ -z "${CHEF_URL}"  ]; then
  CHEF_URL="http://n1nj4net-public.s3-website-us-west-2.amazonaws.com/chef_14.8.10+20181204005213-1_armhf.deb"
  # not used yet
  CHEF_SHA=6a8a9fd8a5ba9ee00f1ab8eb6170fe6de8fb5d97bcd807e8366b9919140f8d2f
fi
CHEF_DEB=$(basename "$CHEF_URL")

dpkg -s chef > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "chef package already installed"
  exit 1
fi

DEPS="curl wget git ntpdate"

dpkg -l $DEPS > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "INFO: getting system fleshed out for download utils and ntpdate"
  apt-get update
  apt-get install -y $DEPS
else
  echo "INFO: system setup for download tools and ntpdate"
fi

echo "INFO: syncing time to pool.ntp.org"
ntpdate -u pool.ntp.org

cd /tmp

echo "INFO: downloading pre-built chef"
echo "INFO: $CHEF_URL"
test -f $CHEF_DEB || curl -O "${CHEF_URL}"
if [ $? -eq 0 ]; then
  echo "downloaded chef: $CHEF_DEB"
else
  echo "ERROR: download of prebuilt deb failed"
  echo "ERROR: failed to download: $CHEF_URL"
  exit 1
fi

test -f $CHEF_DEB && dpkg -i $CHEF_DEB
if [ $? -ne 0 ]; then
  echo "ERROR: failed install of chef: dpkg -i $CHEF_DEB"
  exit 1
else 
  echo "INFO: install of chef successful"
fi
