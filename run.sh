#!/bin/bash
set -x

( cd deployments; docker compose down)

docker volume rm deployments_api-data

./bin/temporal operator namespace create --namespace default

./bin/temporal operator nexus endpoint delete --name billing
./bin/temporal operator nexus endpoint create --name billing --target-namespace default --target-task-queue billing --description test123

./bin/temporal operator nexus endpoint delete --name shipment
./bin/temporal operator nexus endpoint create --name shipment --target-namespace default --target-task-queue shipments --description test123

./bin/temporal operator nexus endpoint delete --name order
./bin/temporal operator nexus endpoint create --name order --target-namespace default --target-task-queue orders --description test123

(cd deployments; docker compose up --build)