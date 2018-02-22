# Vagrant Lucee Development VM 
Local development environment for CFML projects

> (CentOS+Nginx+Tomcat+Lucee+CommandBox)

Vagrant box for local development with Lucee/CommandBox and several utilities.

## Requirements

It is assumed you have Virtual Box and Vagrant installed. If not, then grab the latest version of each at the links below:
* [Virtual Box and Virtual Box Guest Additions](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)

### Vagrant Plugins

Once Vagrant is installed, or if it already is, it's highly recommended that you install the following Vagrant plugins:

* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
```$ vagrant plugin install vagrant-hostsupdater```
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
```$ vagrant plugin install vagrant-vbguest```

---

## What's Included
* [CentOS 7.1 64bit](https://www.centos.org)
	* https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box
* [Nginx Latest](www.nginx.org)
	* Set up to serve all static content and reverse-proxy cfm/cfc/jsp requests to Lucee with URL rewrites enabled
	* Self-signed SSL certificate can be found under `/etc/nginx/ssl` and every site is configured for SSL as well.
	* Nginx configured with high timeouts for development purposes
* [CommandBox](http://www.ortussolutions.com/products/commandbox)
	* Set up to do build processes, REPL, package management or a-la-carte servers if required
	* CommandBox home configured at `/root/.CommandBox`
* [Lucee](www.lucee.org)
	* Set up via reverse-proxy in Nginx and with a control port on 8888
* [Oracle JDK](http://www.oracle.com/technetwork/java/javase/downloads/)
	* Installed globally under `/usr/lib/jvm/current`
* [FakeSMTP](https://nilhcem.github.io/FakeSMTP/)
	* Lucee is configured with a Fake SMTP server that will output all outbound emails to `/opt/fakeSMTP/output` for convenience
	* This is installed under `/opt/fakeSMTP`

---

## Files
This repository is divided in two parts:
-  `vagrant/` : Run all **vagrant** commands from this directory.
    - `artifacts/` : Where downloaded installers will be placed
    - `provisioners/` : The provisionning bash scripts for the box
    - `configs/` : Configuration files for Nginx, Lucee, etc
    - `Vagrantfile/` : The vagrant configuration file
    - `log/` : Where a log file is stored that documents the last provisioning process.
    - `Sample_VagrantConfig.yaml` : A sample configuration file for new sites.  See "Configuring Sites".
- `www/` : Code for the small, default site that shows you the status of your configuration

## Installation
The first time you clone the repo and bring the box up, it may take several minutes. If it doesn't explicitly fail/quit, then it is still working. You can check the log output in the `log` directory to see the output of the commands that have run.

```
$ git clone git@github.com:Ortus-Solutions/vagrant-centos-lucee.git
$ cd vagrant-centos-lucee/vagrant && vagrant up
```

Once the Vagrant box finishes and is ready, you should see something like this in your terminal:

```
==> default: Lucee-Dev-v0.1.0
==> default:
==> default: ========================================================================
==> default:
==> default: http://www.lucee.dev (192.168.50.25)
==> default:
==> default: Lucee Server/Web Context Administrators
==> default:
==> default: http://www.lucee.dev:8888/lucee/admin/server.cfm
==> default: http://www.lucee.dev:8888/lucee/admin/web.cfm
==> default:
==> default: Password (for each admin): password
========================================================================
```

> **Mac Note** : You might be required to enter your administrator password in order to modify the `hosts` file. Unless you run the command with `sudo vagrant up`

Once you see that, you should be able to browse to [http://www.lucee.dev/](http://www.lucee.dev/)
or [http://192.168.1.100/](http://192.168.1.100/)
(it may take a few minutes the first time a page loads after bringing your box up, subsequent requests should be much faster).

## Configuring Sites

This repo only contains the code and configuration for the default site that displays information about your install.  To add a new app to develop on, check out the repo for that app into the same directory that this `vagrant-centos-lucee` is located so sits along side it.  Each app's repo will need to have a folder in the root called `VagrantConfig` that contains one or more YAML files of any name.  

### Sample YAML Configuration File

Here is an example YAML configuration file. It contains the configuration for a single app.  All properties are optional.  `wwwroot` will default to the root of the repo if not specified.

```
# name of the app
name: App 1

# Path to web root relative to the repo root
webroot: www

# List of domains to be added to the Host machine's and VM's "hosts" file
hosts:
- app1.local
- cool.app1.local

# List of CF Mappings to create relative to the repo root
cfmappings: 
- virtual: /foo
  physical: www
- virtual: /bar
  physical: ''

# List of datasources to create
datasources: 
- name: ds1
  database: db1
  host: sqlserverhost
  port: 1433
  class: com.microsoft.jdbc.sqlserver.SQLServerDriver
  dsn: jdbc:sqlserver://{host}:{port}

```
> **Note** : Keys in a YAML file are case-sensitive.

## Folder setup

Here is an overview of the folder structure that should exist on your hard drive including the configuration files.

-  `vagrant-centos-lucee/` : The contents of this repo 
    -  `vagrant/`
    -  `www/`
- `app1/` : An example app
    - `VagrantConfig/`
        - `app1.yaml` : The configuration data for app1`
- `app2/` : Another example app
    - `VagrantConfig/`
        - `app2.yaml` : The configuration data for app2`


## Managing Setup Changes

Every time a new app is added or removed, reboot and reprovision the VM with this command:
```vagrant reload --provision```

All of the hosts will be added to your host machine as well as the VM.  CF mappings and datasources will be added into the Lucee administrator. If more than one site has a mapping or data source with the same name or virtual path, the first one found will be used.

After the re-provisioning is complete, visit the default site to see a current list of the apps that are now configured on the VM.  This page also has links to take you straight to each app as well as the Lucee administrator screens.  Please note, any settings you make in the Lucee administrator will be overwritten when you re-provision the VM.  Consider making changes programmatically via you app's `Application.cfc` file or adding them into the base Vagrant setup.

### Notes
* On Windows (host machines) you should run your terminal as an Administrator; you will also need to make sure your Hosts file isn't set to read-only if you want to take advantage of the hostname functionality. Alternatively, simply use the IP address anywhere you would use the hostname (connecting to database server, etc).

---

## References
* Thanks to Dan Skaggs, as this is a fork of his vagrant box

---

## License
The MIT License (MIT)

Copyright (c) 2015 Dan Skaggs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
