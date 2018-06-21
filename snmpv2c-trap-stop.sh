# #!/usr/bin/env bash


VM="onboarding-VM"
SNMP_TEST="snmpv2c-trap-test"
BLUEPRINT_ID="$VM-snmpv2c-trap"

for i in {1..1}
do
  cfy executions start uninstall -p ignore_failure=true --allow-custom-parameters -d "$SNMP_TEST-$i"
  cfy deployments delete "$SNMP_TEST-$i"
done

cfy blueprints delete "$SNMP_TEST"
cfy uninstall -p ignore_failure=true --allow-custom-parameters "$BLUEPRINT_ID"
