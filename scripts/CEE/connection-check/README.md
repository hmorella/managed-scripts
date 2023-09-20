# Connection check script usage

## Purpose

Provide the functionality to test if a destination (FQDN or IP) has the port open or close from the platform perspective.

## Create the job to run the health check
ocm backplane managedjob create CEE/connection-check -p DESTINATION="`destination`" -p PORT="`port`"

## Getting the result of the job in a file
ocm backplane managedjob logs `jobname`
  
```
$ ocm backplane managedjob logs openshift-job-dev-frbj4
command terminated with exit code 124
close

$ ocm backplane testjob logs openshift-job-dev-s9jx5
open

ocm backplane testjob logs openshift-job-dev-hglsl
close
```

### Usage with managed-scripts

For usage with managed-scripts, the options need to be passed through the `DESTINATION` and `PORT` environment variable. Here are some examples : 

```bash
ocm backplane managedjob create CEE/connection-check  -p DESTINATION="google.com" -p PORT="4433"

ocm backplane managedjob create CEE/connection-check  -p DESTINATION="google.com" -p PORT="443"

ocm backplane managedjob create CEE/connection-check  -p DESTINATION="network-check-target.openshift-network-diagnostics" -p PORT="80"
```


```
