#!/usr/bin/env python

import sys
import subprocess
import uuid
from cloudify import ctx
from cloudify.state import ctx_parameters as inputs

def install_and_import(package):
    import importlib
    try:
        importlib.import_module(package)
    except ImportError:
        import pip
        pip.main(['install', package])
    finally:
        globals()[package] = importlib.import_module(package)


if __name__ == '__main__':
    install_and_import('netifaces')

interface = "eth0"
prefix = "16"

ips = inputs['ips']

ctx.logger.debug("IPS: {}".format(ips))
ctx.logger.info ("Add IP aliases")

process = subprocess.Popen(['sudo','yum','install','epel-release','-y'], stdout=subprocess.PIPE)
process.wait()
ctx.logger.debug("{}".format(process.stdout.read()))
process = subprocess.Popen(['sudo','yum','install','jq.x86_64','lsof','-y'], stdout=subprocess.PIPE)
process.wait()
ctx.logger.debug("{}".format(process.stdout.read()))

# Get first ip
local_ip = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['addr']

# Create file with IP add_aliases
file="/tmp/{}.txt".format(uuid.uuid4().hex)
f= open(file,"w+")

# Add aliases
for ip in ips:
    ctx.logger.debug('IP address: {}'.format(ip['ip_address']))
    f.write('{}\n'.format(ip['ip_address']))
    if ip['ip_address'] != local_ip:
        process = subprocess.Popen(['sudo','ip','addr','add','{}/{}'.format(ip['ip_address'],prefix),'dev', interface], stdout=subprocess.PIPE)
        process.wait()
f.close()
ctx.instance.runtime_properties['ips_file'] = file
