#!/bin/bash

export TEMPORAL_NAMESPACE_MONOLITH="my-monolith-namespace.account"
export TEMPORAL_NAMESPACE_BILLING="my-billing-namespace.account"

# endpoints are global to your account like namespaces
export NEXUS_ENDPOINT_ORDER="my-order-endpoint"
export NEXUS_ENDPOINT_BILLING="my-billing-endpoint"
export NEXUS_ENDPOINT_SHIPMENT="my-shipment-endpoint"

# this likely doesn't need to chage for your environment
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