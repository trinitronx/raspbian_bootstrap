### raspbian_bootstrap ###

### install chef-client on raspberry pi (raspbian).  

Chef doesn't offer a omnibus chef-client for raspberry pi yet.  This bootstrap script helps get around that by building ruby and gem installing chef-client onto the node.

There are bootstrap scripts to support both raspbian-wheezy and raspbian-jessie. Replace the release codename with the OS running on your Raspberry Pi.  For example: Replace `<lsb_codename_here>` in `raspbian-<lsb_codename_here>-gems.erb` with the output of `lsb_release -c -s` on your Pi.

Before you start check the following:
* your chef workstation environment is setup and ready with knife
* your pi is on the network and you can login as root
* have some patience - this will take a while

This script has been tested against raspbian-wheezy, and raspbian-jessie but should likely work gracefully for other Debian-based Linux systems.

## installation ##

    knife bootstrap -t raspbian-$(ssh root@<address_of_your_pi> 'lsb_release -c -s')-gems.erb -x root address_of_your_pi

Or to sudo in via pi user if you don't have root access (I set up my ssh keys first)

    knife bootstrap -t raspbian-$(ssh root@<address_of_your_pi> 'lsb_release -c -s')-gems.erb --ssh-user pi --sudo address_of_your_pi

A full on example of one that applies  What I personally will be doing later for new Pi's is applying my [d-base](https://github.com/dayne/d-base) cookbook as part of default run list.

    knife bootstrap -t raspbian-$(ssh root@<address_of_your_pi> 'lsb_release -c -s')-gems.erb --ssh-user pi --ssh-password '{{password}}' --sudo --node-name NODE_NAME_YOU_WANT --run-list 'recipe[d-base::default]'

## Ramifications of using this script ##

* [ruby-build](https://github.com/rbenv/ruby-build) installed in `/usr/local/bin`
* `/opt/chef` with a ruby 2.2 compiled from ruby-build.
* pi's clock will be synchronized and pi running [ntpd](http://doc.ntp.org/4.1.0/ntpd.htm) (network time protocol daemon).
* `/usr/local/bin/chef-client` to run chef-client with right path for chef & ruby.

## Pre-compiled /opt/chef

Note: I have a short attention span and waiting for ruby to compile on a pi is boring. You have option of using my prebuilt /opt/chef if you want. Just open up the script and twiddle the `false` to `true`. Just look for the comment around line 19. Currently an image only exists for `ruby2.2` built for Raspbian `wheezy`.

# Credits and Contributors

* @tinoschroeter : [Tino Schröter](https://github.com/tinoschroeter/raspbian_bootstrap) as original author
* @dayne : [dayne](http://dayne.broderson.org) updated and evolved to support Chef 12
* @in-bto : [ino-bto](https://github.com/ino-bto) for [trusted certs forwarding to client node](https://github.com/dayne/raspbian_bootstrap/pull/1)
* @Edubits: [Edubits](https://github.com/Edubits) updated to Jessie
* @trinitronx: [trinitronx](https://github.com/trinitronx) Merged support for both Wheezy and Jessie
