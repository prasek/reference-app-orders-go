#!/bin/bash

if [ -f ./setEnv.sh ]; then
    echo sourced from setEnv.sh, delete or modify to use alternate:
    source ./setEnv.sh
fi

echo "+ TEMPORAL_ADDRESS=${TEMPORAL_ADDRESS}"
echo "+ TEMPORAL_NAMESPACE=${TEMPORAL_NAMESPACE}"
echo "+ TEMPORAL_TLS_CERT=${TEMPORAL_TLS_CERT}"
echo "+ TEMPORAL_TLS_KEY=${TEMPORAL_KEY}"

set -x

./temporal "${@:1}"