# Connection check script usage

## Purpose

Provide the functionality to test if a destination (FQDN or IP) has the port open or close from the node perspective.

This script creates a job that runs in the namespace `openshift-backplane-managed-scripts`, which inside the logs of the job pod have the result of the connection check.


## Create the job to run the health check
ocm backplane managedjob create CEE/connection-check -p DESTINATION="`<destination>`" -p PORT="`<port>` -p NODE="`<node>`"

## Getting the result of the job in a file
ocm backplane managedjob logs `<jobname>`

Here are some examples:
  
```
$ ocm backplane managedjob logs openshift-job-dev-g6wxh
The port 80 is OPEN in network-check-target.openshift-network-diagnostics from node ip-10-0-169-251.eu-west-1.compute.internal
```

```
$ ocm backplane managedjob logs openshift-job-dev-pktv5
command terminated with exit code 124
TIMEOUT
The port 800 is CLOSE in network-check-target.openshift-network-diagnostics from node ip-10-0-169-251.eu-west-1.compute.internal
```

```
$ ocm backplane managedjob logs openshift-job-dev-2rhdb
The port 800 is CLOSE in 127.0.0.1 from node ip-10-0-169-251.eu-west-1.compute.internal

```

### Usage with managed-scripts

For usage with managed-scripts, the options need to be passed through the `DESTINATION`, `PORT` and `NODE` environment variables. Here are some examples: 

```bash
ocm backplane managedjob create CEE/connection-check  -p DESTINATION="google.com" -p PORT="4433"

ocm backplane managedjob create CEE/connection-check  -p DESTINATION="google.com" -p PORT="443"

ocm backplane managedjob create CEE/connection-check  -p DESTINATION="network-check-target.openshift-network-diagnostics" -p PORT="80"

ocm backplane managedjob create CEE/connection-check  -p DESTINATION="127.0.0.1" -p PORT="800" -p NODE=ip-10-0-169-251.eu-west-1.compute.internal
```