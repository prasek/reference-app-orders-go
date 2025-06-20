#!/bin/bash

# for run.sh and temporal.sh
if [[ $TEMPORAL_ENV = "billing" ]]; then
    export TEMPORAL_NAMESPACE="billing-ns"
else
    export TEMPORAL_NAMESPACE="order-ns"
fi

echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"

set -x
temporal --version
temporal "${@:1}"
