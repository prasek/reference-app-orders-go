#!/bin/bash

./bin/temporal server start-dev --dynamic-config-value system.enableNexus=true --http-port 7243
