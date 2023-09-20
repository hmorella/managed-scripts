#!/bin/bash

set -u


POD=$(oc get pods -n openshift-network-diagnostics -o jsonpath='{.items[*].metadata.name}' --field-selector spec.nodeName=$NODE | awk '{ print $1 }')

mkdir /tmp/script/
echo "(echo >/dev/tcp/$DESTINATION/$PORT) &>/dev/null && echo "'"'The port $PORT is OPEN in $DESTINATION from node $NODE'"'" || echo "'"'The port $PORT is CLOSE in $DESTINATION from node $NODE'"'""  > /tmp/script/script.sh


oc cp /tmp/script "$POD":/tmp -n openshift-network-diagnostics
oc exec "$POD" -n openshift-network-diagnostics -- sh -c "chmod +x /tmp/script/script.sh"
oc exec "$POD" -n openshift-network-diagnostics -- sh -c "timeout 5 /tmp/script/script.sh > /tmp/result"

oc exec "$POD" -n openshift-network-diagnostics -- sh -c "if [ $? == 0 ]; then cat /tmp/result ; else echo TIMEOUT; fi" > /tmp/result.out

if grep TIMEOUT /tmp/result.out
then
    echo "The port $PORT is CLOSE in $DESTINATION from node $NODE"
else
    cat /tmp/result.out
fi

oc exec "$POD" -n openshift-network-diagnostics -- sh -c "rm /tmp/script/script.sh"
oc exec "$POD" -n openshift-network-diagnostics -- sh -c "rm /tmp/result"

exit 0