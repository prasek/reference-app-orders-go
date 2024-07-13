#!/bin/bash


if [ $1 = "web" ]; then
    (cd ../reference-app-orders-web; pnpm install; pnpm dev)
    exit 0
fi

if [ -f ./setEnv.sh ]; then
    echo sourced from setEnv.sh, delete or modify to use alternate:
    source ./setEnv.sh
fi

echo "+ TEMPORAL_ADDRESS=${TEMPORAL_ADDRESS}"
echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"
echo "+ TEMPORAL_TLS_CERT=${TEMPORAL_TLS_CERT}"
echo "+ TEMPORAL_TLS_KEY=${TEMPORAL_TLS_KEY}"

set -x
go run ./cmd/oms "${@:1}"
