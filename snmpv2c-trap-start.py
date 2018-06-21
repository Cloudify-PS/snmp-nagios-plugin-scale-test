#!/usr/bin/env python

import subprocess
from multiprocessing.dummy import Pool as ThreadPool

vm = "onboarding-VM"
snmp_test = "snmpv2c-trap-test"
blueprint_id = vm + "-snmpv2c"
deployment_id = vm + "-snmpv2c"
deployments = 1
proxy_blueprint = blueprint_id
proxy_deployment = deployment_id

def start_workflow(inputs = None):
    global proxy_blueprint
    global proxy_deployment
    print(str(inputs))
    blueprint_name = inputs[0]
    print(blueprint_name)
    deployment_name = inputs[1]
    print(deployment_name)
    process = subprocess.Popen([ 'cfy', 'deployments', 'create', '-b',
        blueprint_name, deployment_name, '-i', 'proxy_blueprint=' + proxy_blueprint,
        '-i', 'proxy_deployment=' + proxy_deployment ], stdout=subprocess.PIPE)
    process.wait()
    subprocess.Popen(['cfy', 'executions', 'start', 'install', '-d', deployment_name])
    process.wait()


process = subprocess.Popen(['cfy','install', '-b', blueprint_id, '-d', deployment_id,  'blueprints/' + vm + '.yaml',
  '-i', 'inputs/' + deployment_id + '-trap-inputs.yaml', '-i',  'inputs/ips-v2c-trap-inputs.yaml'])
process.wait()

process = subprocess.Popen(['cfy','blueprints', 'upload','-b', snmp_test, 'blueprints/' + snmp_test + '.yaml' ])
process.wait()

inputs = []

for i in range(0, deployments):
    inputs.append(['snmpv2c-trap-test', 'snmpv2c-trap-test-'+ str(i)])
print (str(inputs))
pool = ThreadPool(4)
results = pool.map(start_workflow, inputs)
pool.close()
pool.join()
