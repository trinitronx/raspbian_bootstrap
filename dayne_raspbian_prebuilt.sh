BUILT_CHEF_TGZ=http://n1nj4net-public.s3-website-us-west-2.amazonaws.com/raspbian-opt_chef-r233c121831.tgz

if [ ! -f /usr/bin/chef-client ]; then
  apt-get update
  apt-get install -y curl wget git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ntpdate

  ntpdate -u pool.ntp.org

if [ ! -d /opt/chef ] ; then
  pushd .
  cd /
  # Change to true to use a prebuilt (by @dayne) /opt/chef
  echo "downloading pre-built raspbian-opt_chef ruby for /opt/chef"
  curl $BUILT_CHEF_TGZ | tar xz
  if [ $? != 0 ]; then
    echo "curl of raspbian-opt_chef failed - try using ruby build instead"
    exit 1
  fi
fi
