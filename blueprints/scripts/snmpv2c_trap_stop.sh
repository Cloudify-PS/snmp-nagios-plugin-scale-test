#!/usr/bin/env bash

ctx logger debug "IP: $ip"

sudo kill -9 `cat /run/trap_$ip.pid`
sudo rm -f /run/trap_$ip.pid
