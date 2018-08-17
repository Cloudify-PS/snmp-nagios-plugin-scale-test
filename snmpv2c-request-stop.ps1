# #!/usr/bin/env bash


$VM = "onboarding-VM"
$SNMP_TEST = "snmpv2c-request-test"
$BLUEPRINT_ID = "$VM-request-snmpv2c"
$DEPLOYMENTS = 1
$SCALE_CYCLES = 40
$DELTA="-10"

for ($i=0; $i -le $DEPLOYMENTS - 1; $i++) {
  for ($k=0; $k -le $SCALE_CYCLES -1; $k++) {
    cfy executions start scale -d $SNMP_TEST-$i -p '"scalable_entity_name"="snmp_simulation_group";"delta"="' + $DELTA + '"'
  }
  cfy executions start uninstall -p ignore_failure=true --allow-custom-parameters -d $SNMP_TEST-$i
  cfy deployments delete $SNMP_TEST-$i
}

cfy blueprints delete $SNMP_TEST
cfy uninstall -p ignore_failure=true --allow-custom-parameters $BLUEPRINT_ID
