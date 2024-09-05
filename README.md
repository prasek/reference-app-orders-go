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

![OMS logo](docs/images/oms-logo.png)

The Order Management System (OMS) is a reference application that 
demonstrates one way to approach the design and implementation of 
an order processing system based on Temporal Workflows. You can run 
this application locally (directly on a laptop) or in a Kubernetes 
cluster. In addition, the required Temporal Service can be run locally, 
or be provided by a remote self-hosted deployment, or be provided by 
Temporal Cloud. 

## Quickstart
We recommend that you begin by reading the [documentation](docs/README.md), 
which will explain the features of the application and aspects 
of its design. It also provides instructions for deploying and 
running the application in various environments.

If you'd like to jump right in and run the OMS locally, clone this 
repository to your machine and follow the steps below. Unless otherwise 
noted, you should execute the commands from the root directory of your 
clone.

### Start the Temporal Service
Run the following command in your terminal:

```command
temporal server start-dev --ui-port 8080 --db-filename temporal-persistence.db
```

The Temporal Service manages application state by assigning tasks
related to each Workflow Execution and tracking the completion of 
those tasks. The detailed history it maintains for each execution 
enables the application to recover from a crash by reconstructing 
its pre-crash state and resuming the execution.

### Start the Workers
Run the following command in another terminal:

```command
go run ./cmd/oms worker
```

This command starts both Workflow and Activity Workers in a single
process. The Workers run Workflow and Activity functions, which 
carry out the various aspects of order processing.

### Start the API Servers
Run the following command in another terminal:
```command
go run ./cmd/oms api
```

The API Servers provide REST APIs that the web application uses to 
interact with the OMS. 


### Run the Web Application
You will need to clone the code for the web application, which is 
maintained separately in the 
[reference-app-orders-web](https://github.com/temporalio/reference-app-orders-web) 
repository:

```command
cd ..
git clone https://github.com/temporalio/reference-app-orders-web.git
```

You will then need to run the following commands to start it:

```command
cd reference-app-orders-web
pnpm install
pnpm dev
```

You will then be able to access the OMS web application at 
<http://localhost:5173/> and the Temporal Web UI at 
<http://localhost:8080/>. In the OMS web application, select 
the **User** role, and then submit an order (we recommend 
choosing order #1 to start). Next, return to the main page
of the web application, select the **Courier** role, locate
the shipments corresponding to your order, and then click 
the **Dispatch** and **Deliver** buttons to complete the 
process. As you proceed with each of these steps, be sure 
to refresh the Temporal Web UI so that you can see the 
Workflows created and updated as a result. 


## Find Your Way Around
This repository provides four subdirectories of interest:

| Directory                                             | Description                                                       |
| ----------------------------------------------------- | ----------------------------------------------------------------- |
| <code><a href="app/">app/</a></code>                  | Application code                                                  |
| <code><a href="cmd/">cmd/</a></code>                  | Command-line tools provided by the application                    |
| <code><a href="deployments/">deployments/</a></code>  | Tools and configuration files used to deploy the application      |
| <code><a href="docs/">docs/</a></code>                | Documentation                                                     |

See the [documentation](docs/README.md) for more information.
