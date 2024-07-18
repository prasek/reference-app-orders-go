#!/bin/bash

if [ -f ./setEnv.sh ]; then
    echo sourced from setEnv.sh, delete or modify to use alternate:
    source ./setEnv.sh
fi

echo "+ TEMPORAL_OPS_API=${TEMPORAL_OPS_API}"
echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"

set -x

rm -f api-store.db

#delete endpoints
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name billing
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name shipment
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name order

#create endpoints
until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name $NEXUS_ENDPOINT_BILLING \
  --target-task-queue billing \
  --target-namespace $TEMPORAL_NAMESPACE \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done

until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name $NEXUS_ENDPOINT_SHIPMENT \
  --target-task-queue shipments \
  --target-namespace $TEMPORAL_NAMESPACE \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done

until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name $NEXUS_ENDPOINT_ORDER \
  --target-task-queue orders \
  --target-namespace $TEMPORAL_NAMESPACE \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done