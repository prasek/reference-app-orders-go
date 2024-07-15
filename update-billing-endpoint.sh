#!/bin/bash
set -x

#update billing endpoint
#tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint update \
#  --name billing \
#  --target-task-queue billing \
#  --target-namespace nexus-demo-billing.temporal-dev \
#  --description-file description.md

#delete endpoints
tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint delete \
  --name billing

#create endpoints
until tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint create \
  --name billing \
  --target-task-queue billing \
  --target-namespace nexus-demo-billing.temporal-dev \
  --allow-namespace nexus-demo-monolith.temporal-dev \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done