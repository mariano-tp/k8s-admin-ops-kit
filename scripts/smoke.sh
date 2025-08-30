#!/usr/bin/env bash
set -euo pipefail
NS=${NS:-bot}
echo "[Smoke] Resources in $NS"
kubectl -n "$NS" get deploy,po,svc
echo "[Smoke] Curl svc/bot-platform-api from a temp pod"
kubectl -n "$NS" run curl --image=curlimages/curl:8.7.1 -i --rm -q --restart=Never -- curl -sS http://bot-platform-api
