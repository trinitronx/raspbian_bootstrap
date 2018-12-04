# steps if you want to install chef
# via the system ruby and gems

# current chef requires ruby-2.5 or later so
# this no longer works on raspbian until they get 
# a newer ruby.  use the omnibus builder

# Update the Apt index
apt-get update

# Set a hold on any upgrades to Apt
apt-mark hold apt

# Install new packages
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ruby ruby-dev curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

apt-mark unhold apt

gem install moneta --no-rdoc --no-ri --verbose
gem install net-ssh-gateway --no-rdoc --no-ri --verbose
gem install net-ssh --no-rdoc --no-ri --verbose
gem install ohai --no-rdoc --no-ri --verbose
gem install chef --no-rdoc --no-ri --verbose
