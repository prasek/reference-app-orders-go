#!/bin/bash

if [ -f ./setEnv.sh ]; then
    echo sourced from setEnv.sh, delete or modify to use alternate:
    source ./setEnv.sh
fi

echo "+ TEMPORAL_OPS_API=${TEMPORAL_OPS_API}"
echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"

set -x

#update billing endpoint
#tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint update \
#  --name billing \
#  --target-task-queue billing \
#  --target-namespace nexus-demo-billing.temporal-dev \
#  --description-file description.md

#delete endpoints
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name billing

#create endpoints
until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name billing \
  --target-task-queue billing \
  --target-namespace $TEMPORAL_NAMESPACE_BILLING \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done