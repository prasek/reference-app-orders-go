#!/bin/bash

set -x

curl -sSf https://temporal.download/cli.sh | sh -s -- --version v0.14.0-nexus.0 --dir .

./bin/temporal --version

./bin/temporal server start-dev --dynamic-config-value system.enableNexus=true --http-port 7243