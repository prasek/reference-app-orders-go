#!/bin/bash

set -x

./bin/temporal operator nexus endpoint delete --name billing
./bin/temporal operator nexus endpoint create --name billing --target-namespace billing --target-task-queue billing --description test123