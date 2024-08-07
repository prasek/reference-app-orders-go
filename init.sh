#!/bin/bash
set -x

#if local
rm -f ./api-store.db

#if using https://github.com/prasek/docker-compose/tree/nexus
docker volume rm -f deployments_api-data

./bin/temporal operator namespace create --namespace monolith
./bin/temporal operator namespace create --namespace billing

./bin/temporal operator nexus endpoint delete --name billing
./bin/temporal operator nexus endpoint create --name billing --target-namespace monolith --target-task-queue billing --description test123

./bin/temporal operator nexus endpoint delete --name shipment
./bin/temporal operator nexus endpoint create --name shipment --target-namespace monolith --target-task-queue shipments --description test123

./bin/temporal operator nexus endpoint delete --name order
./bin/temporal operator nexus endpoint create --name order --target-namespace monolith --target-task-queue orders --description test123
