#!/usr/bin/env bash

ctx logger debug "IP: $ip"


sudo kill -9 `cat /tmp/$ip.pid`
sudo rm -f /tmp/$ip.pid

sudo kill -9 `cat /tmp/trap_$ip.pid`
sudo rm -f /tmp/trap_$ip.pid
