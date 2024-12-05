#!/bin/bash
set -x

#if local
rm -f ./api-store.db

temporal operator namespace create --namespace order-ns
temporal operator namespace create --namespace billing-ns

temporal operator nexus endpoint delete --name billing
temporal operator nexus endpoint create --name billing --target-namespace order-ns --target-task-queue billing --description test123

temporal operator nexus endpoint delete --name shipment
temporal operator nexus endpoint create --name shipment --target-namespace order-ns --target-task-queue shipments --description test123

temporal operator nexus endpoint delete --name order
temporal operator nexus endpoint create --name order --target-namespace order-ns --target-task-queue orders --description test123
