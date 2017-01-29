### raspbian_bootstrap ###

### install `chef-client` on raspberry pi (`raspbian`).

Chef doesn't offer a omnibus `chef-client` for raspberry pi yet.  This `knife bootstrap` script helps get around that by offering you a few methods to get a Raspberry Pi ready chef-client.  

There are bootstrap scripts to support both `raspbian-wheezy` and `raspbian-jessie`. The commands below replace the release codename with the OS running on your Raspberry Pi. If for some reason you do not wish to run `ssh` in the subshell, just replace it manually.

For example: Replace `<lsb_codename_here>` in `raspbian-<lsb_codename_here>-gems.erb` with the output of `lsb_release -c -s` on your Pi.

Before you start check the following:

* your chef workstation environment is setup and ready with `knife`
* your pi is on the network and you can login as root
* have some patience - this will take a while - especially the ruby-build route

This script has been tested against `raspbian-wheezy`, and `raspbian-jessie` but should likely work gracefully for other Debian-*based* Linux systems.

The older raspbian-wheezy will use [ruby-build](https://github.com/rbenv/ruby-build) to build a ruby and then install chef into /opt/chef. _This will take a long time_

The raspbian-jessie has some options to get ruby and chef: compile with ruby-build, prebuilt bundle, or adding a new apt repository to get ruby2.3.  The default is my to build it.  Prefix your `knife bootstrap` like `OPT=prebuilt knife bootstrap` with the following options:

* **`OPT=build`**  - Default: Uses [ruby-build](https://github.com/rbenv/ruby-build) to build a new ruby - _Slow: This will take a long time_
* **`OPT=prebuilt`** - Same as above, only it comes from a tar.gz bundle [I](http://github.com/dayne) did. _Fast: Only do this if you are Dayne or trust me_
* **`OPT=stretch`**  - Adds the *stretch* apt repository to pi and installs ruby-2.3 from apt . _Fast: Do this if you don't mind new apt repo on your pi_

## installation ##

    knife bootstrap -t raspbian-$(ssh root@<address_of_your_pi> \ 
                         'lsb_release -c -s')-gems.erb -x root address_of_your_pi

Or to sudo in via pi user if you don't have root access

    knife bootstrap -t raspbian-$(ssh root@<address_of_your_pi> \
            'lsb_release -c -s')-gems.erb --ssh-user pi --sudo address_of_your_pi

## Ramifications of using this script ##

* [`ruby-build`](https://github.com/rbenv/ruby-build) installed in `/usr/local/bin`
* `/opt/chef` with a ruby (`wheezy: 2.2`, `jessie: 2.3`) compiled from `ruby-build`
  * Or possibly ruby from stretch repo if you choose that option for jessie.
* pi's clock will be synchronized and pi running [`ntpd`](http://doc.ntp.org/4.1.0/ntpd.htm) (network time protocol daemon).
* `/usr/local/bin/chef-client` to run `chef-client` with right path for Chef & `ruby`.

## Pre-compiled /opt/chef

Note: I have a short attention span and waiting for ruby to compile on a pi is boring. You have option of using my prebuilt `/opt/chef` if you want using that `OPT=prebuilt` flag on the jessie bootstrap.  That option is also available for wheezy - Just open up the script and twiddle the `false` to `true`. Just look for the comment around **line 19**. Currently an image only exists for `ruby2.2` built for Raspbian `wheezy`.

A full on example of a `knife` command that applies a Chef recipe. Using my own d-base recipe and taking advantage of my pre-built /opt/chef

    OPT=prebuilt knife bootstrap -t raspbian-jessiegems.erb -u pi -x \
                  -N NODE_NAME --run-list 'recipe[d-base::default]' ADDRESS_OF_PI


# Credits and Contributors

* @tinoschroeter : [Tino Schröter](https://github.com/tinoschroeter/raspbian_bootstrap) as original author
* @dayne : [dayne](http://dayne.broderson.org) updated and evolved to support Chef 12
* @in-bto : [ino-bto](https://github.com/ino-bto) for [trusted certs forwarding to client node](https://github.com/dayne/raspbian_bootstrap/pull/1)
* @Edubits: [Edubits](https://github.com/Edubits) updated to Jessie
* @trinitronx: [trinitronx](https://github.com/trinitronx) Merged support for both Wheezy and Jessie
