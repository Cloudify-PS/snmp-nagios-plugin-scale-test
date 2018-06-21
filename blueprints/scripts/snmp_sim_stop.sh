#!/usr/bin/env bash

sudo kill -9 `cat /tmp/$ip.pid`
sudo rm -f /tmp/$ip.pid
