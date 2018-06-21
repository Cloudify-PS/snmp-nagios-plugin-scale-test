#!/usr/bin/env bash

curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python2.7

sudo pip install snmpsim
sudo yum install -y net-snmp-utils
