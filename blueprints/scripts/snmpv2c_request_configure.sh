#!/usr/bin/env bash
ctx logger info "Configure cloudify_monitoring in snmpsim"
sudo cp -r /usr/snmpsim/data/public /usr/snmpsim/data/cloudify_monitoring
sync
sudo cp -r /usr/snmpsim/data/public.snmprec /usr/snmpsim/data/cloudify_monitoring.snmprec
sync

sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.1\|4:numeric\|scale=15,rate=0.01,deviation=1,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.1\|4:numeric\|scale=1,rate=0.01,deviation=0,function=cos,min=0,max=1/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sync
sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.2\|4:numeric\|scale=10,rate=0.005,deviation=1,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.2\|4:numeric\|scale=1,rate=0.01,deviation=0,function=cos,min=0,max=1/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sync
sudo sed -i s/1.3.6.1.4.1.2021.10.1.3.3\|4:numeric\|scale=8,rate=0.001,deviation=1,function=cos,min=0/1.3.6.1.4.1.2021.10.1.3.3\|4:numeric\|scale=1,rate=0.001,deviation=0,function=cos,min=0,max=1/g /usr/snmpsim/data/cloudify_monitoring.snmprec
sync
