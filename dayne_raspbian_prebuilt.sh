#!/bin/bash
#

CHEF_URL="http://n1nj4net-public.s3-website-us-west-2.amazonaws.com/chef_14.8.10+20181204005213-1_armhf.deb"
CHEF_DEB=$(basename "$CHEF_URL")
CHEF_SHA=6a8a9fd8a5ba9ee00f1ab8eb6170fe6de8fb5d97bcd807e8366b9919140f8d2f

dpkg -s chef > /dev/null 2>&1
if [ $? == 0 ]; then
  echo "chef package already installed"
  exit 1
fi

DEPS="curl wget git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ntpdate"

dpkg -l $DEPS > /dev/null
if [ $? != 0 ]; then
  echo "INFO: getting system fleshed out for dev tools and ntpdate"
  apt-get update
  apt-get install -y $DEPS
else
  echo "INFO: system setup for dev tools and ntpdate"
fi

echo "INFO: syncing time to pool.ntp.org"
ntpdate -u pool.ntp.org

cd /tmp
echo "INFO: downloading pre-built chef"
echo "INFO: $CHEF_URL"
test -f $CHEF_DEB || curl -O "${CHEF_URL}"
if [ $? != 0 ]; then
  echo "ERROR: download of prebuilt deb failed"
  echo "ERROR: failed to download: $CHEF_URL"
  exit 1
fi
test -f $CHEF_DEB && dpkg -i $CHEF_DEB
if [ $? != 0 ]; then
  echo "ERROR: failed: dpkg -i $CHEF_DEB"
  exit 1
else 
  echo "INFO: install of chef successful"
fi
