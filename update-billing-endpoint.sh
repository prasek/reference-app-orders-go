#!/bin/bash

set -x

temporal operator nexus endpoint update --name billing --target-namespace billing-ns --target-task-queue billing --description test123