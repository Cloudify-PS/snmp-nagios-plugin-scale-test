#!/usr/bin/env bash

$VM = "onboarding-VM"

$SNMP_TEST = "snmpv2c-request-test"
$BLUEPRINT_ID = "$VM-request-snmpv2c"
$DEPLOYMENT_ID = "$VM-request-snmpv2c"
$DEPLOYMENTS = 1
$SCALE_CYCLES = 40
$DELTA="+10"

cfy install -b $BLUEPRINT_ID -d $DEPLOYMENT_ID blueprints\$VM.yaml `
  -i inputs\$DEPLOYMENT_ID-inputs.yaml -i inputs\ips-v2c-request-inputs.yaml

cfy blueprints upload -b $SNMP_TEST blueprints\$SNMP_TEST.yaml

for ($i=0; $i -le $DEPLOYMENTS - 1; $i++) {
  cfy deployments create -b $SNMP_TEST $SNMP_TEST-$i `
    -i proxy_blueprint=$BLUEPRINT_ID -i proxy_deployment=$DEPLOYMENT_ID `
    -i instances=1
  cfy executions start install -d $SNMP_TEST-$i
  for ($k=0; $k -le $SCALE_CYCLES -1; $k++) {
    cfy executions start scale -d $SNMP_TEST-$i -p '"scalable_entity_name"="snmp_simulation_group";"delta"="' + $DELTA + '"'
  }
}
