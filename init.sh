#!/bin/bash
set -x

rm -f api-store.db

#delete endpoints
tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint delete \
  --name billing
tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint delete \
  --name shipment
tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint delete \
  --name order

#create endpoints
tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint create \
  --name billing \
  --target-task-queue billing \
  --target-namespace nexus-demo-bugbash.temporal-dev \
  --allow-namespace nexus-demo-bugbash.temporal-dev \
  --description-file description.md

tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint create \
  --name shipment \
  --target-task-queue shipments \
  --target-namespace nexus-demo-bugbash.temporal-dev \
  --allow-namespace nexus-demo-bugbash.temporal-dev \
  --description-file description.md

tcld --server "saas-api.tmprl-test.cloud:443" nexus endpoint create \
  --name order \
  --target-task-queue orders \
  --target-namespace nexus-demo-bugbash.temporal-dev \
  --allow-namespace nexus-demo-bugbash.temporal-dev \
  --description-file description.md