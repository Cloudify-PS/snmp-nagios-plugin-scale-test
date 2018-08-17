#!/usr/bin/env bash

ctx logger info "NAGIOS IP: $NAGIOS_IP, IP: $ip, user: $user"

arg="--process-user=$user --process-group=$user --agent-udpv4-endpoint=$ip:161 --daemonize --cache-dir=/var/tmp/$ip/cache --v2c-arch --pid-file=/tmp/$ip.pid"
ctx logger debug "ARG=$arg"
sudo snmpsimd.py $arg

mkdir -p /home/centos/.snmp/mibs

ctx download-resource resources/mibs/F5-BIGIP-COMMON-MIB.txt '@{"target_path": "/home/centos/.snmp/mibs/F5-BIGIP-COMMON-MIB.txt"}'

ctx download-resource resources/trap.sh '@{"target_path": "/tmp/trap.sh"}'

sudo chmod 755 /tmp/trap.sh

/tmp/trap.sh $NAGIOS_IP $ip &

echo $! | sudo tee /tmp/trap_$ip.pid
