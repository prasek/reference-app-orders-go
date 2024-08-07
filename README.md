# Nexus demo

### Prerequisites
- Golang 1.22+
- `pnpm`


### Demo app
```
git clone https://github.com/prasek/reference-app-orders-go.git
git clone https://github.com/temporalio/reference-app-orders-web.git

cd reference-app-orders-go

git checkout nexus
```

### Get `temporal` CLI v0.14.0-nexus.0

1. Go to the [CLI release page](https://github.com/temporalio/cli/releases/tag/v0.14.0-nexus.0) and download an archive
   for your OS and architecture.
2. Extract the downloaded archive into the `./bin` directory.

or alternatively:

```
curl -sSf https://temporal.download/cli.sh | sh -s -- --version v0.14.0-nexus.0 --dir .

./bin/temporal --version
```

### Spin up environment

#### Start temporal server

```
./bin/temporal server start-dev --dynamic-config-value system.enableNexus=true --http-port 7243
```

### Create Nexus endpoints and namespaces

Create the namespaces and endpoints using `./bin/temporal` see [./init.sh](init.sh):
```
./init.sh
```

### Bring up the demo app components

in `reference-app-orders-go` open separate terminal windows

window 1:
```
./run.sh worker
```

window 2:
```
./run.sh api
```

window 3:
```
./run.sh web
```

#### Bring up the Temporal UI

open http://localhost:8233/ for the Temporal UI

and don't forget to enable Labs mode for the UI in the lower left corner!

### Start a workflow to process `Order 1`
1. open http://localhost:5173 for the demo app UI
1. click `Customer` role
1. click `New Order`
1. select Order 1
1. click `Submit Order`

### Observe the workflow state in a new terminal

using the provided `./bin/temporal` CLI (from github.com/temporalio/cli@nexus)

```
./bin/temporal workflow list -n monolith
```

#### Look at history for the `Order` workflow

```
./bin/temporal workflow show -n monolith -w <order workflow>
```

#### Describe the shipping workflow to see the Nexus callback status

```
./bin/temporal workflow describe -n monolith -w <shipping workflow>
```

## (Optional) update billing endpoint to route to a different namespace

### Create billing namespace and endpoint

```
./update-billing-endpoint.sh
```

### Split out separate billing worker

Stop `./run.sh worker`

window 1 using monolith namespace
```
./run.sh worker --services order,shipment
```

window 2 using billing namespace (see ./setEnv.sh)
```
TEMPORAL_ENV=billing ./run.sh worker --services billing
```

### Place another order and verify it still works

1. Place another order
1. Verify order and shipment Nexus ops and workflows created in the monolith namespace
1. Verify billing Nexus ops and workflow created in the billing namespace

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
