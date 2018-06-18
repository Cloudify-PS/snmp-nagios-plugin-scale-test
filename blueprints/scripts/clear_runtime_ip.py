#!/usr/bin/env python

from cloudify import ctx
from cloudify.state import ctx_parameters as inputs
import fcntl
import os

# put line into ips_file
ip = None
ctx.logger.info('IPS_FILE: {}'.format(inputs['ips_file']))
f = open('{}'.format(inputs['ips_file']), 'a')
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
f.write('{}\n'.format(inputs['ip']))
fcntl.flock(f, fcntl.LOCK_UN)
f.close()

ctx.logger.info("ip: {} back to file.".format(ip))
