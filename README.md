> Available languages / Idiomas disponibles: [*English*](README.md) / [*Español*](README.ES.md)

[![ci](https://img.shields.io/github/actions/workflow/status/mariano-tp/k8s-admin-ops-kit/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/actions/workflows/ci.yml)
[![last commit](https://img.shields.io/github/last-commit/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/commits/main)
[![release](https://img.shields.io/github/v/release/mariano-tp/k8s-admin-ops-kit?display_name=tag&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/releases)
[![license: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)
[![stars](https://img.shields.io/github/stars/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/stargazers)

# Kubernetes Admin Ops Kit

Runbooks-as-code for typical Kubernetes administrator tasks. Includes Ansible for L2/L3 operations, Helm for packaging a sample app, and CI with KinD.

Designed for technical interviews: showcases automation, controlled rollouts, health checks, and reproducible validation fully in GitHub Actions.

## What gets validated in CI (GitHub Actions)
The workflow provisions everything in an ephemeral KinD cluster and validates the full flow:

- Creates a KinD cluster on an Ubuntu runner
- Runs Helm chart validation (lint + template)
- Installs the chart and checks rollouts/readiness
- Executes Ansible playbooks (smoke + basic operational tasks)
- Runs a smoke test to confirm the platform is healthy

Evidence: workflow logs in Actions.

## Contents
- helm/bot-platform/ - Helm chart with 3 Deployments (api/worker/nlp), PDB, NetworkPolicy, and probes
- ansible/playbooks/ - Operational playbooks (ordered restart, cordon/drain, rollback, secret rotation)
- scripts/ - Scripts to spin up KinD and run smoke tests
- .github/workflows/ci.yml - CI that creates KinD, validates Helm, installs the chart, runs Ansible, and executes smoke tests
- observability/ - Base values for kube-prometheus-stack (optional)
- runbooks/ - Short SOPs for operations

## Validate 100% online (GitHub Actions)
1. Push this repo to GitHub
2. Go to Actions -> ci -> Run workflow
3. The workflow should turn green

## Quick start (local optional)
Local setup is optional. It can be useful for development and troubleshooting.

    ./scripts/kind-up.sh

    helm upgrade --install bot-platform ./helm/bot-platform -n bot --create-namespace

    kubectl -n bot rollout status deploy -l app.kubernetes.io/name=bot-platform --timeout=300s

    python3 -m venv .venv && source .venv/bin/activate
    pip install -r requirements.txt
    ansible-galaxy collection install -r ansible/collections/requirements.yml
    export K8S_AUTH_KUBECONFIG=$HOME/.kube/config
    ansible-playbook ansible/playbooks/restart-platform.yml -e namespace=bot

    ./scripts/smoke.sh

## Structure
    k8s-admin-ops-kit/
    ├─ ansible/
    │ ├─ inventory/hosts.ini
    │ ├─ collections/requirements.yml
    │ └─ playbooks/
    │   ├─ restart-platform.yml
    │   ├─ cordon-drain-node.yml
    │   ├─ rollout-undo.yml
    │   └─ rotate-secret.yml
    ├─ helm/
    │ └─ bot-platform/
    │   ├─ Chart.yaml
    │   ├─ values.yaml
    │   └─ templates/
    │       ├─ deploy-api.yaml
    │       ├─ deploy-worker.yaml
    │       ├─ deploy-nlp.yaml
    │       ├─ svc-api.yaml
    │       └─ netpol.yaml
    ├─ scripts/
    │ ├─ kind-up.sh
    │ ├─ kind-down.sh
    │ └─ smoke.sh
    ├─ runbooks/
    │ ├─ 01-restart-platform.md
    │ └─ 02-node-maintenance.md
    ├─ observability/kube-prometheus-stack-values.yaml
    ├─ .github/workflows/ci.yml
    ├─ requirements.txt
    ├─ LICENSE
    └─ README.md

## CI workflow summary
Each push/PR triggers the workflow that:
1. Creates KinD on an Ubuntu runner
2. Runs Helm validation and installs the chart
3. Executes Ansible automation (basic operational tasks)
4. Waits for readiness and runs scripts/smoke.sh

## Credits
Portfolio repository by @mariano-tp. Licensed under MIT.

See also: [Code of Conduct](./CODE_OF_CONDUCT.md) · [Contributing](./CONTRIBUTING.md) · [Security](./SECURITY.md)

