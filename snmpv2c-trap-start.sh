#!#!/usr/bin/env bash


VM="onboarding-VM"
SNMP_TEST="snmpv2c-trap-test"
BLUEPRINT_ID="$VM-trap-snmpv2c"
DEPLOYMENT_ID="$VM-trap-snmpv2c"

cfy install -b "$BLUEPRINT_ID" -d "$DEPLOYMENT_ID" "blueprints/$VM.yaml" \
  -i "$DEPLOYMENT_ID-trap-inputs.yaml" -i "inputs/ips-v2c-trap-inputs.yaml"

cfy blueprints upload -b "$SNMP_TEST" "blueprints/$SNMP_TEST.yaml"

for i in {1..1}
do
  cfy deployments create -b "$SNMP_TEST" "$SNMP_TEST-$i" \
    -i proxy_blueprint="$BLUEPRINT_ID" -i proxy_deployment="$DEPLOYMENT_ID"
  cfy executions start install -d "$SNMP_TEST-$i"
done
