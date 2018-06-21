#!/usr/bin/env bash

ctx logger info "NAGIOS IP: $NAGIOS_IP, IP: $ip, user: $user"

sudo cp -r /usr/snmpsim/data/public /usr/snmpsim/data/cloudify_monitoring
sudo cp -r /usr/snmpsim/data/public.snmprec /usr/snmpsim/data/cloudify_monitoring.snmprec

sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.1\|4:numeric\|scale=15,rate=0.01,deviation=1,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.1\|4:numeric\|scale=1,rate=0.01,deviation=0,function=cos,min=0.6,max=0.6/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.2\|4:numeric\|scale=10,rate=0.005,deviation=1,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.2\|4:numeric\|scale=1,rate=0.01,deviation=0,function=cos,min=0.6,max=0.6/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.3\|4:numeric\|scale=8,rate=0.001,deviation=1,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.3\|4:numeric\|scale=1,rate=0.001,deviation=0,function=cos,min=0.6,max=0.6/g /usr/snmpsim/data/cloudify_monitoring.snmprec

arg="--process-user=$user --process-group=$user --agent-udpv4-endpoint=$ip:161 --daemonize --cache-dir=/var/tmp/$ip/cache --v2c-arch --pid-file=/tmp/$ip.pid"
ctx logger debug "ARG=$arg"
sudo snmpsimd.py $arg

mkdir -p /home/centos/.snmp/mibs

ctx download-resource resources/mibs/F5-BIGIP-COMMON-MIB.txt '@{"target_path": "/home/centos/.snmp/mibs/F5-BIGIP-COMMON-MIB.txt"}'

ctx download-resource resources/trap.sh '@{"target_path": "/tmp/trap.sh"}'

sudo chmod 755 /tmp/trap.sh

/tmp/trap.sh $NAGIOS_IP $ip &

echo $! | sudo tee /tmp/trap_$ip.pid
