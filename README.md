# Nexus demo

```
git clone https://github.com/prasek/reference-app-orders-go.git

cd reference-app-orders-go

git checkout nexus
```

### Get `temporal` CLI v0.14.0-nexus.0

```
curl -L https://github.com/temporalio/cli/releases/download/v0.14.0-nexus.0/temporal_cli_0.14.0-nexus.0_darwin_arm64.tar.gz > temporal.tar.gz

tar -xvzf temporal.tar.gz temporal

./temporal --version

rm temporal.tar.gz
```


### Spin up environment

#### Start temporal server

```
./temporal server start-dev --dynamic-config-value system.enableNexus=true --http-port 7243
```

#### Bring up the rest of the environment

```
./run.sh
```

#### Bring up the Temporal UI


open http://localhost:8233/ for the Temporal UI

and don't forget to enable Labs mode for the UI in the lower left corner!

### Start a workflow to process `Order 1`
1. open http://localhost:3001 for the demo app UI
1. click `Customer` role
1. click `New Order`
1. select Order 1
1. click `Submit Order`

### Observe the workflow state in a new terminal

using the provided `./bin/temporal` CLI (from github.com/temporalio/cli@nexus)

```
./temporal workflow list
```

#### Look at history for the `Order` workflow

```
./temporal workflow show -w <order workflow>
```

#### Describe the shipping workflow to see the Nexus callback status

```
./temporal workflow describe -w <shipping workflow>
```

1. ensure `NexusOperationScheduled` is reported in the caller's workflow history
   - it should start the underlying `Charge` workflow

1. ensure `NexusOperationStarted` is reported in the caller's workflow history
   - verify the `Charge` workflow completes successfully

1. ensure `NexusOperationCompleted` is reported in the Order workflow history
   - should indicate the underlying `Charge` workflow was completed successfully

### Observe Temporal server logs for additional info
1. ensure callback is delivered

---------------------------------

# Temporal Reference Application: Order Management System

Note: This application is still pre-release, in active development.
For the best experience, please check back later.
We'll be releasing soon, along with comprehensive documentation!

## Finding your way around the repository

* `app/` Application code
* `cmd/` Command line tools for the application
* `deployments/` Tools to deploy the application
* `docs/` Documentation

### To run all Worker and API services

`go run ./cmd/oms worker`
`go run ./cmd/oms api`

### To run web

See: https://github.com/temporalio/reference-app-orders-web
