# Nexus demo

```
git clone https://github.com/prasek/reference-app-orders-go.git

cd reference-app-orders-go

git checkout nexus
```

### Build temporal CLI from source with golang 1.22+

If you don't have golang on your system: https://go.dev/doc/install

Then build the temporal CLI with Nexus support available:

```
git submodule init
git submodule update

cd temporal-cli
go build ./cmd/temporal
cp ./temporal ../
cd ..
```


### Spin up environment

#### Start temporal server

```
./temporal server start-dev --dynamic-config-value system.enableNexus=true --http-port 7243
```

Or alternatively:
- Launch the `Debug Server with SQLite` from https://github.com/temporalio/temporal `main`

#### Bring up the rest of the environment

```
./run.sh
```

#### Optionally bring up the Temporal UI

build the Temporal UI:
```
cd temporal-ui
npm install
npm run build:server
cd ..
```

run the Temporal UI on port 3000
```
./run-ui.sh
```

open http://localhost:3000 for the Temporal UI

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
