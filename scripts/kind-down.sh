#!/usr/bin/env bash
set -euo pipefail
CLUSTER_NAME=${CLUSTER_NAME:-ops-kit}
kind delete cluster --name "$CLUSTER_NAME"
