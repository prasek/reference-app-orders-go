#!/bin/bash

if [ -f ./setEnv.sh ]; then
    echo sourced from setEnv.sh, delete or modify to use alternate:
    source ./setEnv.sh
fi

echo "+ TEMPORAL_OPS_API=${TEMPORAL_OPS_API}"
echo "+ TEMPORAL_NAMESPACE_BILLING=${TEMPORAL_NAMESPACE_BILLING}"

set -x

#update billing endpoint
tcld --server "$TEMPORAL_OPS_API" nexus endpoint update \
  --name $NEXUS_ENDPOINT_BILLING \
  --target-task-queue billing \
  --target-namespace $TEMPORAL_NAMESPACE_BILLING \
  --description-file description.md