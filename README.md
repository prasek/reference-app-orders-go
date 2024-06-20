# Nexus demo

### Spin up environment

Launch the `Debug Server with SQLite` from https://github.com/temporalio/temporal `main`

Then spin up the environment:
```
./setup.sh
```

### Start a workflow to process `Order 1`
1. open http://localhost:3000
1. click `Customer` role
1. click `New Order`
1. select Order 1
1. click `Submit Order`

### Observe the workflow state in a new terminal

using the provided `./bin/temporal` CLI (from github.com/temporalio/cli@nexus)

```
./bin/temporal workflow list
```

#### Look at history for the `Order` workflow

```
./bin/temporal workflow show -w <order workflow>
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
