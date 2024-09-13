#!/bin/bash

echo "resetting database, please recycle the api server as it's caching"

set -x

rm -f api-store.db