### raspbian_bootstrap ###

### install `chef-client` on raspberry pi (`raspbian`).

Chef doesn't offer a omnibus `chef-client` for raspberry pi **yet**. Any minute now.

This `knife bootstrap` script helps get around that by either building a chef omnibus from scratch or using a pre-build deb package using my [chef_omnibus_build](https://gist.github.com/dayne/330c331ef2b5a69b318f5fb01c49b40a) tool.

Before you start check the following:

* your chef workstation environment is setup and ready with `knife`
* your pi is on the network and you can login as root
* have some patience - this will take a while - especially the ruby-build route

This script has been tested against `raspbian-stretch` and may work gracefully for other Debian-*based* Linux systems.

The `raspbian_bootstrap.erb` uses an `OPT` environent variable to provide provides different options to get ruby and chef: `build` to compile with [chef_omnibus_build](https://gist.github.com/dayne/330c331ef2b5a69b318f5fb01c49b40a) or a `prebuilt` debian I've already built and host.

Prefix your `knife bootstrap` like `OPT=prebuilt knife bootstrap` with the following options:
* **`OPT=build`**  -  Uses my omnibus_builder script to build a new ruby, omnibus-toolchain, and then chef.
 *  _Slow: This will take a long time_
 * Note: This also creates an omnibus build user (locked password).
* **`OPT=prebuilt`** - Same as above, only it comes from a prebuilt debian
 * _Fast: Only do this if you are Dayne or trust Dayne_

## installation ##

`git clone https://github.com/dayne/raspbian_bootstrap`

`knife bootstrap -t raspbian_bootstrap.erb -x root PI_ADDRESS`

Or to sudo in via pi user if you don't have root access

`knife bootstrap -t raspbian_bootstrap.erb --ssh-user pi --sudo PI_ADDRESS`

## Ramifications of using this script ##

* Chef installed
* pi's clock will be synchronized and pi running [`ntpd`](http://doc.ntp.org/4.1.0/ntpd.htm) (network time protocol daemon).
* `/usr/local/bin/chef-client` to run `chef-client` with right path for Chef & `ruby`.

A full on example of a `knife` command that applies a Chef recipe. Using my own d-base recipe and taking advantage of my pre-built /opt/chef

    OPT=prebuilt knife bootstrap -t raspbian_bootstrap.erb -x pi --sudo \
                  -N NODE_NAME --run-list 'recipe[d-base::default]' ADDRESS_OF_PI

# Credits and Contributors

* @tinoschroeter : [Tino Schröter](https://github.com/tinoschroeter/raspbian_bootstrap) as original author
* @dayne : [dayne](http://dayne.broderson.org) updated and evolved to support Chef 12
* @in-bto : [ino-bto](https://github.com/ino-bto) for [trusted certs forwarding to client node](https://github.com/dayne/raspbian_bootstrap/pull/1)
* @Edubits: [Edubits](https://github.com/Edubits) updated to Jessie
* @trinitronx: [trinitronx](https://github.com/trinitronx) Merged support for both Wheezy and Jessie
* @marcusbooyah: [marcusbooyah](https://github.com/marcusbooyah) Tested and [fixed bugs in `OPT=stretch`](https://github.com/dayne/raspbian_bootstrap/pull/5)
