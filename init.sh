#!/bin/bash
set -x

rm -f ./api-store.db

./bin/temporal operator namespace create --namespace monolith
./bin/temporal operator namespace create --namespace billing

./bin/temporal operator nexus endpoint delete --name billing
./bin/temporal operator nexus endpoint create --name billing --target-namespace monolith --target-task-queue billing --description test123

./bin/temporal operator nexus endpoint delete --name shipment
./bin/temporal operator nexus endpoint create --name shipment --target-namespace monolith --target-task-queue shipments --description test123

./bin/temporal operator nexus endpoint delete --name order
./bin/temporal operator nexus endpoint create --name order --target-namespace monolith --target-task-queue orders --description test123