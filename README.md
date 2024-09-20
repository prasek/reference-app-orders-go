# Nexus demo on Temporal Cloud

### Prerequisites
- Golang 1.22+
- `pnpm`

### Demo app
```
git clone https://github.com/prasek/reference-app-orders-go.git
git clone https://github.com/prasek/reference-app-orders-web.git

cd reference-app-orders-go

git checkout nexus-cloud
```

#### Download latest tcld & temporal CLI

Download the latest tcld and temporal CLI binaries:

```
brew install temporalio/brew/tcld
brew install temporal
```

### Generate certs
```
mkdir -p $HOME/nexus-demo/certs 
cd $HOME/nexus-demo/certs
tcld gen ca --org temporal -d 1y --ca-cert ca.pem --ca-key ca.key
cat ca.pem
cd -
```

### Create monolith namespace with Nexus enabled

Create your namespace with `ca.pem` and then get your namespace enabled for Nexus

Name this namespace: `<prefix>-monolith`

### Setup tcld

Login via `tcld`
```
tcld login
```

### Create Nexus endpoints

in `reference-app-orders-go`, update [./setEnv.sh](setEnv.sh) for your environment

Create the endpoints using `tcld` see [./init.sh](init.sh):
```
./init.sh
```

Change the endpoint names the ones you created above at L23-25 in `reference-app-orders-go/app/order/workflow.go`

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

### Start a workflow to process `Order 1`
1. open http://localhost:5173 for the demo app UI
1. click `Customer` role
1. click `New Order`
1. select Order 1
1. click `Submit Order`

### View Workflows and Nexus Operations in Temporal Cloud UI

open the Temporal UI and don't forget to enable Labs mode for the UI in the lower left corner!

see Nexus Operations in Workflow history


### Complete workflow as `Courier` role

1. Dispatch order
1. Deliver order

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
using the `temporal.sh` wrapper 

```
./temporal.sh workflow list
```

#### Look at history for the `Order` workflow

```
./temporal.sh workflow show -w <order workflow>
```

which will show:
```
+ temporal workflow show -w Order:A1-1726764867236
Progress:
  ID           Time                     Type
    1  2024-09-19T16:54:33Z  WorkflowExecutionStarted
    2  2024-09-19T16:54:33Z  WorkflowTaskScheduled
    3  2024-09-19T16:54:33Z  WorkflowTaskStarted
    4  2024-09-19T16:54:33Z  WorkflowTaskCompleted
    5  2024-09-19T16:54:33Z  ActivityTaskScheduled
    6  2024-09-19T16:54:33Z  ActivityTaskStarted
    7  2024-09-19T16:54:33Z  ActivityTaskCompleted
    8  2024-09-19T16:54:33Z  WorkflowTaskScheduled
    9  2024-09-19T16:54:33Z  WorkflowTaskStarted
   10  2024-09-19T16:54:33Z  WorkflowTaskCompleted
   11  2024-09-19T16:54:33Z  MarkerRecorded
   12  2024-09-19T16:54:33Z  MarkerRecorded
   13  2024-09-19T16:54:33Z  NexusOperationScheduled
   14  2024-09-19T16:54:33Z  NexusOperationStarted
   15  2024-09-19T16:54:33Z  WorkflowTaskScheduled
   16  2024-09-19T16:54:33Z  WorkflowTaskStarted
   17  2024-09-19T16:54:33Z  WorkflowTaskCompleted
   18  2024-09-19T16:54:34Z  NexusOperationCompleted
   19  2024-09-19T16:54:34Z  WorkflowTaskScheduled
   20  2024-09-19T16:54:34Z  WorkflowTaskStarted
   21  2024-09-19T16:54:34Z  WorkflowTaskCompleted
   22  2024-09-19T16:54:34Z  NexusOperationScheduled
   23  2024-09-19T16:54:34Z  NexusOperationStarted
   24  2024-09-19T16:54:34Z  WorkflowTaskScheduled
   25  2024-09-19T16:54:34Z  WorkflowTaskStarted
   26  2024-09-19T16:54:34Z  WorkflowTaskCompleted
   27  2024-09-19T16:54:34Z  WorkflowExecutionSignaled
   28  2024-09-19T16:54:34Z  WorkflowTaskScheduled
   29  2024-09-19T16:54:35Z  WorkflowTaskStarted
   30  2024-09-19T16:54:35Z  WorkflowTaskCompleted
   31  2024-09-19T16:56:37Z  WorkflowExecutionSignaled
   32  2024-09-19T16:56:37Z  WorkflowTaskScheduled
   33  2024-09-19T16:56:37Z  WorkflowTaskStarted
   34  2024-09-19T16:56:37Z  WorkflowTaskCompleted
   35  2024-09-19T16:56:38Z  WorkflowExecutionSignaled
   36  2024-09-19T16:56:38Z  WorkflowTaskScheduled
   37  2024-09-19T16:56:38Z  WorkflowTaskStarted
   38  2024-09-19T16:56:38Z  WorkflowTaskCompleted
   39  2024-09-19T16:56:38Z  NexusOperationCompleted
   40  2024-09-19T16:56:38Z  WorkflowTaskScheduled
   41  2024-09-19T16:56:38Z  WorkflowTaskStarted
   42  2024-09-19T16:56:38Z  WorkflowTaskCompleted
   43  2024-09-19T16:56:38Z  MarkerRecorded
   44  2024-09-19T16:56:38Z  WorkflowExecutionCompleted
```

or the JSON output
```
./temporal.sh workflow show --output json -w <order workflow>
```

which will show:

##### NexusOperationScheduled
```
   {
      "eventId": "13",
      "eventTime": "2024-09-19T16:54:33.471317119Z",
      "eventType": "EVENT_TYPE_NEXUS_OPERATION_SCHEDULED",
      "version": "1265",
      "taskId": "172827111",
      "nexusOperationScheduledEventAttributes": {
        "endpoint": "billing",
        "service": "billing",
        "operation": "charge",
        "input": {
          "metadata": {
            "encoding": "anNvbi9wbGFpbg=="
          },
          "data": "eyJjdXN0b21lcklkIjoiMTIzNCIsIm9yZGVyUmVmZXJlbmNlIjoiQTEtMTcyNjc2NDg2NzIzNjoxIiwiaXRlbXMiOlt7InNrdSI6IlZhbnMgT2xkIFNrb29sIiwicXVhbnRpdHkiOjF9XSwiaWRlbXBvdGVuY3lLZXkiOiI4NTZjZjZhNi0wOGMxLTQ1ZWUtOTk3Yy1mYjRjZTZkYTk4MTEifQ=="
        },
        "scheduleToCloseTimeout": "3600s",
        "workflowTaskCompletedEventId": "10",
        "requestId": "b71fa8b6-54ad-4db9-993b-8f16292edb6e",
        "endpointId": "20c5d237559148b49a93db87cc41ef74"
      }
    },
```

##### NexusOperationStarted
```
   {
      "eventId": "14",
      "eventTime": "2024-09-19T16:54:33.747315959Z",
      "eventType": "EVENT_TYPE_NEXUS_OPERATION_STARTED",
      "version": "1265",
      "taskId": "172827115",
      "links": [
        {
          "workflowEvent": {
            "namespace": "nexus-demo-billing.a2dd6",
            "workflowId": "Charge:856cf6a6-08c1-45ee-997c-fb4ce6da9811",
            "runId": "7215d7b6-d559-4d0a-8548-8a6f93876cd1",
            "eventRef": {
              "eventType": "EVENT_TYPE_WORKFLOW_EXECUTION_STARTED"
            }
          }
        }
      ],
      "nexusOperationStartedEventAttributes": {
        "scheduledEventId": "13",
        "operationId": "Charge:856cf6a6-08c1-45ee-997c-fb4ce6da9811",
        "requestId": "b71fa8b6-54ad-4db9-993b-8f16292edb6e"
      }
    },
```

##### NexusOperationCompleted
```
    {
      "eventId": "18",
      "eventTime": "2024-09-19T16:54:34.276806875Z",
      "eventType": "EVENT_TYPE_NEXUS_OPERATION_COMPLETED",
      "version": "1265",
      "taskId": "172827126",
      "nexusOperationCompletedEventAttributes": {
        "scheduledEventId": "13",
        "result": {
          "metadata": {
            "encoding": "anNvbi9wbGFpbg=="
          },
          "data": "eyJpbnZvaWNlUmVmZXJlbmNlIjoiQTEtMTcyNjc2NDg2NzIzNjoxIiwic3ViVG90YWwiOjk4NTIsInNoaXBwaW5nIjo5NDIsInRheCI6MTk3MCwidG90YWwiOjEyNzY0LCJzdWNjZXNzIjp0cnVlLCJhdXRoQ29kZSI6IjEyMzQifQ=="
        },
        "requestId": "b71fa8b6-54ad-4db9-993b-8f16292edb6e"
      }
    },
```

#### Describe the shipping workflow to see the Nexus callback status

```
./temporal.sh workflow describe -w <shipping workflow>
```

1. ensure `NexusOperationScheduled` is reported in the caller's workflow history
   - it should start the underlying `Charge` workflow
1. ensure `NexusOperationStarted` is reported in the caller's workflow history
   - verify the `Charge` workflow completes successfully
1. ensure `NexusOperationCompleted` is reported in the Order workflow history
   - should indicate the underlying `Charge` workflow was completed successfully
1. ensure shipping workflow reports

```
Callbacks: 1

  URL               https://nexus.nexus-demo-monolith.a2dd6.cluster.tmprl.cloud:7243/namespaces/nexus-demo-monolith.a2dd6/nexus/callback
  Trigger           WorkflowClosed
  State             Succeeded
  Attempt           1
  RegistrationTime  6 minutes ago


Results:
  RunTime         6m53.85s
  Status          COMPLETED
  Result          {"CourierReference":"A1-1721334713213:1:1234"}
  ResultEncoding  json/plain
```
## (Optional) update billing endpoint to route to a different namespace

### Create billing namespace with Nexus enabled

Create your namespace with `ca.pem` and then get your namespace enabled for Nexus

Name this namespace: `<prefix>-billing`

### Update billing endpoint
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
