#!/bin/bash
# This script is adopt from internal SOP.

set -u


POD=$(oc get pods -n openshift-network-diagnostics -o jsonpath='{.items[*].metadata.name}' | awk '{ print $1 }')

mkdir /tmp/script/
echo "(echo >/dev/tcp/$DESTINATION/$PORT) &>/dev/null && echo "open" || echo "close"" > /tmp/script/script.sh


oc cp /tmp/script "$POD":/tmp -n openshift-network-diagnostics
oc exec "$POD" -n openshift-network-diagnostics -- sh -c "chmod +x /tmp/script/script.sh"
oc exec "$POD" -n openshift-network-diagnostics -- sh -c "timeout 5 /tmp/script/script.sh > /tmp/result"

oc exec "$POD" -n openshift-network-diagnostics -- sh -c "if [ $? == 0 ]; then cat /tmp/result ; else echo "close"; fi"

oc exec "$POD" -n openshift-network-diagnostics -- sh -c "rm /tmp/script/script.sh"
oc exec "$POD" -n openshift-network-diagnostics -- sh -c "rm /tmp/result"

exit 0
