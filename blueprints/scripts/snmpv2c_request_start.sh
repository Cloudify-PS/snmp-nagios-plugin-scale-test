#!/usr/bin/env bash

ctx logger debug "User $user, IP: $ip"

mkdir -p /var/tmp/cache/$ip
arg="--process-user=$user --process-group=$user --agent-udpv4-endpoint=$ip:161 --daemonize --cache-dir=/var/tmp/cache/$ip --v2c-arch --pid-file=/tmp/$ip.pid"
ctx logger debug "ARG=$arg"
sudo snmpsimd.py $arg

PID=`pgrep -F /tmp/$ip.pid`
if  `ps -p $PID > /dev/null`; then
    ctx logger info "snmpsim is running on $ip. PID: $PID"
else
    exit 1
fi
