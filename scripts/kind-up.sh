#!/usr/bin/env bash
set -euo pipefail
CLUSTER_NAME=${CLUSTER_NAME:-ops-kit}
KIND_NODE_IMAGE=${KIND_NODE_IMAGE:-kindest/node:v1.29.2}
cat <<YAML | kind create cluster --name "$CLUSTER_NAME" --image "$KIND_NODE_IMAGE" --config -
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
YAML
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system rollout status deploy/metrics-server --timeout=180s
echo "[OK] KinD listo:"
kubectl config current-context
