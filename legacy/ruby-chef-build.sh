RUBY_VER=2.5.3

if [ ! -f /usr/bin/chef-client ]; then
  apt-get update
  apt-get purge ruby1.9 ruby ruby2.3-y
  apt-get install -y curl wget git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ntpdate

  ntpdate -u pool.ntp.org

  if [ ! -d /opt/chef ] ; then
    pushd .
    cd /
    if [ ! -d /usr/local/src/ruby-build ]; then
      echo "installing ruby-build"
      git clone https://github.com/rbenv/ruby-build.git /usr/local/src/ruby-build
      cd /usr/local/src/ruby-build
      ./install.sh
    else
      cd /usr/local/src/ruby-build
      git pull
      ./install.sh
    fi
    mkdir -p /opt/chef
    if [ ! -f /opt/chef/bin/ruby ]; then
      echo "installing ruby $RUBY_VER into /opt/chef using ruby-build"
      /usr/local/bin/ruby-build $RUBY_VER /opt/chef
    fi
    popd
  fi
fi

PATH=/opt/chef/bin:$PATH
export PATH

ruby --version | grep $RUBY_VER
if [ $? != 0 ]; then
   echo "ERROR: /opt/chef/bin/ruby is not expected version: $RUBY_VER -- got: `ruby --version`"
   exit
fi

gem install moneta --no-rdoc --no-ri --verbose
gem install net-ssh-gateway --no-rdoc --no-ri --verbose
gem install net-ssh --no-rdoc --no-ri --verbose
gem install ohai --no-rdoc --no-ri --verbose
gem install chef --no-rdoc --no-ri --verbose
