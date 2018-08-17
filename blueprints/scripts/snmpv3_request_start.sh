#!/usr/bin/env bash

ctx logger debug "User $user, IP: $ip"

sudo cp -r /usr/snmpsim/data/public /usr/snmpsim/data/cloudify_monitoring
sync
sudo cp -r /usr/snmpsim/data/public.snmprec /usr/snmpsim/data/cloudify_monitoring.snmprec

sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.1\|4:numeric\|scale=1,rate=0.01,deviation=0,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.1\|4:numeric\|scale=1,rate=0.01,deviation=1,function=cos,min=0,max=1/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.2\|4:numeric\|scale=1,rate=0.001,deviation=0,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.2\|4:numeric\|scale=1,rate=0.01,deviation=1,function=cos,min=0,max=1/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.3\|4:numeric\|scale=1,rate=0.001,deviation=0,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.3\|4:numeric\|scale=1,rate=0.001,deviation=1,function=cos,min=0,max=1/g /usr/snmpsim/data/cloudify_monitoring.snmprec


arg="--process-user=$user --process-group=$user --agent-udpv4-endpoint=$ip:161 --daemonize --cache-dir=/var/tmp/$ip/cache --v3-only --pid-file=/tmp/$ip.pid --v3-user=cloudify_monitoring --v3-auth-key=snmpnagiostestauth --v3-auth-proto=SHA --v3-priv-key=snmpnagiostestpriv --v3-priv-proto=AES"
ctx logger debug "ARG=$arg"
sudo snmpsimd.py $arg
