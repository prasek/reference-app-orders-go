#!/bin/bash
set -x

( cd deployments; docker compose down)

docker volume rm deployments_api-data

./temporal operator namespace create --namespace default

./temporal operator nexus endpoint delete --name billing
./temporal operator nexus endpoint create --name billing --target-namespace default --target-task-queue billing --description test123

./temporal operator nexus endpoint delete --name shipment
./temporal operator nexus endpoint create --name shipment --target-namespace default --target-task-queue shipments --description test123

./temporal operator nexus endpoint delete --name order
./temporal operator nexus endpoint create --name order --target-namespace default --target-task-queue orders --description test123

(cd deployments; docker compose up --build)