#!/bin/bash

# create namespaces first then add their names here
export TEMPORAL_NAMESPACE_MONOLITH="my-monolith-namespace.account"
export TEMPORAL_NAMESPACE_BILLING="my-billing-namespace.account"

# endpoints are global to your account like namespaces
# you can create these manually with the UI or `tcld nexus endpoint create`
# or use `./init.sh` create them using the
# endpoint names you provide here
# this likely doesn't need to change, unless running in a shared environment
# make corresponding changes in https://github.com/prasek/reference-app-orders-go/blob/9bc1a35248eb9d0b5e6c0f8db731bb2f6c811fec/app/order/workflows.go#L23
export NEXUS_ENDPOINT_ORDER="order"
export NEXUS_ENDPOINT_BILLING="billing"
export NEXUS_ENDPOINT_SHIPMENT="shipment"

# this likely doesn't need to change for your environment
export TEMPORAL_TLS_CERT="$HOME/nexus-demo/certs/ca.pem"
export TEMPORAL_TLS_KEY="$HOME/nexus-demo/certs/ca.key"
export TEMPORAL_OPS_API="saas-api.tmprl.cloud:443"

# for run.sh and temporal.sh
if [[ $TEMPORAL_ENV = "billing" ]]; then
    export TEMPORAL_ADDRESS="${TEMPORAL_NAMESPACE_BILLING}.tmprl.cloud:7233"
    export TEMPORAL_NAMESPACE="${TEMPORAL_NAMESPACE_BILLING}"
else
    export TEMPORAL_ADDRESS="${TEMPORAL_NAMESPACE_MONOLITH}.tmprl.cloud:7233"
    export TEMPORAL_NAMESPACE="${TEMPORAL_NAMESPACE_MONOLITH}"
fi

if [[ $TEMPORAL_NAMESPACE_MONOLITH = "my-monolith-namespace.account" ]]; then
    echo "ERROR: ./setEnv.sh must be updated to use the namespaces and Nexus endpoints for your environment"
    exit 1
fi
