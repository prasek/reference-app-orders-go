#!/bin/bash

# for run.sh and temporal.sh
if [[ $TEMPORAL_ENV = "billing" ]]; then
    export TEMPORAL_ADDRESS="nexus-demo-billing.a2dd6.tmprl.cloud:7233"
    export TEMPORAL_NAMESPACE="nexus-demo-billing.a2dd6"
else
    export TEMPORAL_ADDRESS="nexus-demo-monolith.a2dd6.tmprl.cloud:7233"
    export TEMPORAL_NAMESPACE="nexus-demo-monolith.a2dd6"
fi

export TEMPORAL_TLS_CERT="$HOME/nexus-demo/certs/ca.pem"
export TEMPORAL_TLS_KEY="$HOME/nexus-demo/certs/ca.key"

# for init.sh
export TEMPORAL_OPS_API="saas-api.tmprl.cloud:443"
export TEMPORAL_NAMESPACE_BILLING="nexus-demo-billing.a2dd6"