# #!/usr/bin/env bash


VM="onboarding-VM"
SNMP_TEST="snmpv3-request-test"
BLUEPRINT_ID="$VM-request-snmpv3"

for i in {1..1}
do
  cfy executions start uninstall -p ignore_failure=true --allow-custom-parameters -d "$SNMP_TEST-$i"
  cfy deployments delete "$SNMP_TEST-$i"
done

cfy blueprints delete "$SNMP_TEST"
cfy uninstall -p ignore_failure=true --allow-custom-parameters "$BLUEPRINT_ID"
