#!/bin/bash

# for run.sh and temporal.sh
if [[ $TEMPORAL_ENV = "billing" ]]; then
    export TEMPORAL_NAMESPACE="billing"
else
    export TEMPORAL_NAMESPACE="monolith"
fi

echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"

if [ $1 = "web" ]; then
    (set -x; cd ../reference-app-orders-web; pnpm install; pnpm dev)
    exit 0
fi

set -x
go run ./cmd/oms "${@:1}"