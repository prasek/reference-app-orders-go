#!/bin/bash

rm -f api-store.db

if [ -f ./setEnv.sh ]; then
    echo sourced from setEnv.sh, delete or modify to use alternate:
    source ./setEnv.sh
fi

echo "+ TEMPORAL_OPS_API=${TEMPORAL_OPS_API}"
echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"

set -x

#delete endpoints
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name billing
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name shipment
tcld --server "$TEMPORAL_OPS_API" nexus endpoint delete \
  --name order

#create endpoints
until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name billing \
  --target-task-queue billing \
  --target-namespace $TEMPORAL_NAMESPACE \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done

until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name shipment \
  --target-task-queue shipments \
  --target-namespace $TEMPORAL_NAMESPACE \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done

until tcld --server "$TEMPORAL_OPS_API" nexus endpoint create \
  --name order \
  --target-task-queue orders \
  --target-namespace $TEMPORAL_NAMESPACE \
  --allow-namespace $TEMPORAL_NAMESPACE \
  --description-file description.md
do
  echo "Try again"
  sleep 1
done