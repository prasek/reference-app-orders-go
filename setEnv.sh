#!/bin/bash

if [[ $TEMPORAL_ENV = "billing" ]]; then
    export TEMPORAL_ADDRESS="nexus-demo-billing.temporal-dev.tmprl-test.cloud:7233"
    export TEMPORAL_NAMESPACE="nexus-demo-billing.temporal-dev"
else
    export TEMPORAL_ADDRESS="nexus-demo-monolith.temporal-dev.tmprl-test.cloud:7233"
    export TEMPORAL_NAMESPACE="nexus-demo-monolith.temporal-dev"
fi

export TEMPORAL_TLS_CERT="$HOME/nexus-demo/certs/ca.pem"
export TEMPORAL_TLS_KEY="$HOME/nexus-demo/certs/ca.key"