#!/usr/bin/env python

from cloudify import ctx
from cloudify.state import ctx_parameters as inputs
import fcntl
import os


# get line from ips_file
data = None
ip = None
ctx.logger.info('IPS_FILE: {}'.format(inputs['ips_file']))
f = open('{}'.format(inputs['ips_file']), 'r+')
while True:
    try:
        fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
        break
    except IOError as e:
        # raise on unrelated IOErrors
        if e.errno != errno.EAGAIN:
            raise
        else:
            time.sleep(0.1)

data = f.read().splitlines(True)
ip = data[0]
f.seek(0)
f.truncate()
f.writelines(data[1:])
fcntl.flock(f, fcntl.LOCK_UN)
f.close()

ctx.logger.info("Set runtime property ip: {}".format(ip))
ctx.instance.runtime_properties['ip'] = ip.rstrip(os.linesep)
