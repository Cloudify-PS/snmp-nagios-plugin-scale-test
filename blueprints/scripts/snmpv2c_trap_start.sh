#!/usr/bin/env bash

ctx logger debug "NAGIOS IP: $NAGIOS_IP, IP: $ip"

WAIT=600

echo $$ | sudo tee /run/trap_$ip.pid

while true
do
  sleep $(($WAIT + ( RANDOM % 10 )  + 1 ))
  snmptrap -v2c -c testcommunity $NAGIOS_IP "" iso.3.6.1.4.1.3375.2.4.0.10 \
    iso.3.6.1.4.1.3375.2.4.1.1 s "Pool /Cloudify_01/FastL4Applications/pglbs_pool member /Cloudify_01/10.10.10.8:0 monitor status down. [ /Common/gateway_icmp: down; last error:  ]  [ was unchecked for 0hr:0min:16sec ]" \
    iso.3.6.1.6.3.1.1.4.1.0 o F5-BIGIP-COMMON-MIB::bigipServiceDown iso.3.6.1.4.1.3375.2.4.1.2 s "/Cloudify_01/$ip"
done
