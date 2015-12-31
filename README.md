### raspbian_bootstrap ###

To install chef-client on raspberry pi (raspbian).  

Before you start make sure of the following
* your chef workstation envornment is setup and ready for knife
* your pi is on the network and you can login as root
* have some patience - this will take a while

## installation ##

    knife bootstrap -t raspbian-wheezy-gems.erb -x root address_of_your_pi

Or to sudo in via pi user if you don't have root access (I set up my ssh keys first)

    knife bootstrap -t raspbian-wheezy-gems.erb --ssh-user pi --sudo address_of_your_pi

What I personally will be doing later for new Pi's is applying my [d-base](https://github.com/dayne/d-base) cookbook as part of default run list.

    knife bootstrap -t raspbian-wheezy-gems.erb --ssh-user pi --ssh-password '{{password}}' --sudo --node-name NODE_NAME_YOU_WANT --run-list 'recipe[d-base::default]'

## Ramifications of doing this ##

The pi will have ruby-build installed in /usr/local/bin so you can build more ruby fun if you want.

You'll have /opt/chef with a ruby 2.2 compiled from ruby-build.

Your pi's clock will be sycnronized and you'll will be running ntp.

You'll have a /usr/local/bin/chef-client to run chef-client with right path for chef & ruby.

*Note:* This bootstraps just runs chef-client once.  This does not setup any chef-client as a daemon stuff.

# Credits and Contributors

* @tinoschroeter : [Tino Schröter](https://github.com/tinoschroeter/raspbian_bootstrap) as original author
* @dayne : [dayne](http://dayne.broderson.org) updated and evolved to support Chef 12
* @in-bto : [ino-bto](https://github.com/ino-bto) for [trusted certs forwarding to client node](https://github.com/dayne/raspbian_bootstrap/pull/1)
