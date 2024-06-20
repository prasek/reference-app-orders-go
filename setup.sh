docker volume rm deployments_api-data

./bin/temporal operator namespace create --namespace default
./bin/temporal operator nexus endpoint delete --name billing
./bin/temporal operator nexus endpoint create --name billing --target-namespace default --target-task-queue billing --description test123