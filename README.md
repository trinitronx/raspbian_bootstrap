### raspbian_bootstrap ###

To install chef-client on raspberry pi (raspbian).  

Before you start make sure of the following
* your chef workstation envornment is setup and ready for knife
* your pi is on the network and you can login as root
* have some patience - this will take a while

## installation ##

knife bootstrap -t raspbian-wheezy-gems.erb -x root ip or fqdn of your pi

## Ramifications of doing this ##

The pi will have ruby-build installed in /usr/local/bin so you can build more ruby fun if you want.

You'll have /opt/chef with a ruby 2.2 compiled from ruby-build.

Your pi's clock will be sycnronized and you'll will be running ntp.

You'll have a /usr/local/bin/chef-client to run chef-client with right path for chef & ruby.

*Note:* This bootstraps just runs chef-client once.  This does not setup any chef-client as a daemon stuff.

