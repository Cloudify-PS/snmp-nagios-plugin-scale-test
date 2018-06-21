#!#!/usr/bin/env bash


VM="onboarding-VM"
SNMP_TEST="snmpv2c-request-test"
BLUEPRINT_ID="$VM-request-snmpv2c"
DEPLOYMENT_ID="$VM-request-snmpv2c"
INSTANCES=200

cfy install -b "$BLUEPRINT_ID" -d "$DEPLOYMENT_ID" "blueprints/$VM.yaml" \
  -i "inputs/$DEPLOYMENT_ID-inputs.yaml" -i "inputs/ips-v2c-request-inputs.yaml"

cfy blueprints upload -b "$SNMP_TEST" "blueprints/$SNMP_TEST.yaml"

for i in {1..1}
do
  cfy deployments create -b "$SNMP_TEST" "$SNMP_TEST-$i" \
    -i proxy_blueprint="$BLUEPRINT_ID" -i proxy_deployment="$DEPLOYMENT_ID" \
    -i instances="$INSTANCES"
  cfy executions start install -d "$SNMP_TEST-$i"
done
