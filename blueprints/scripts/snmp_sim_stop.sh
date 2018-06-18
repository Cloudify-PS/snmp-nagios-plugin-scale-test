#!/usr/bin/env bash

sudo kill -9 `cat /run/$ip.pid`
sudo rm -f /run/$ip.pid
