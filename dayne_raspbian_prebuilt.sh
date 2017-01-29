BUILT_CHEF_TGZ=http://n1nj4net-public.s3-website-us-west-2.amazonaws.com/raspbian_chef-v12.18.31-r2.3.3.tar.gz


DEPS="curl wget git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ntpdate"

dpkg -l $DEPS > /dev/null
if [ $? != 0 ]; then
  echo "INFO: getting system fleshed out for dev tools and ntpdate"
  apt-get update
  apt-get install -y curl wget git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ntpdate
else
  echo "INFO: system allready nicely setup for dev tools and ntpdate"
fi

ntpdate -u pool.ntp.org

if [ ! -d /opt/chef ] ; then
  cd /opt/
  echo "INFO: downloading pre-built raspbian-opt_chef ruby for /opt/chef"
  echo "INFO: $BUILT_CHEF_TGZ "
  curl $BUILT_CHEF_TGZ | tar xz
  if [ $? != 0 ]; then
    echo "ERROR: download of prebuilt bundle failed - try using ruby build instead"
    echo "ERROR: failed to download: $BUILT_CHEF_TGZ"
    exit 1
  else 
    echo "INFO: extraction of prebuilt ruby and chef into /opt/chef successful"
  fi
else 
  echo "WARNING: /opt/chef folder already exists - skipped install of prebuilt chef"
fi
