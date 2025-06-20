#!/bin/bash

set -euo pipefail
set -x

# Delete and create the remote destination endpoint that targets a namespace/taskqueu
temporal operator nexus endpoint delete --name billing-remote || true
temporal operator nexus endpoint create \
  --name billing-remote \
  --target-namespace billing-ns \
  --target-task-queue billing \
  --description test123 \
  --output json

ENDPOINT_JSON=$(temporal operator nexus endpoint get \
  --name billing-remote \
  --output json)

# Use jq to extract the ID
ENDPOINT_ID=$(echo "$ENDPOINT_JSON" | jq -r '.id')

# Delete and create a local proxy Nexus Endpoint that targets the remote Nexus Endpoint to forward requests
temporal operator nexus endpoint delete --name billing || true
temporal operator nexus endpoint create \
  --name billing \
  --target-url "http://localhost:7243/nexus/endpoints/$ENDPOINT_ID/services" \
  --description test123

