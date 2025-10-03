[![ci](https://img.shields.io/github/actions/workflow/status/mariano-tp/k8s-admin-ops-kit/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/actions/workflows/ci.yml)
[![last commit](https://img.shields.io/github/last-commit/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/commits/main)
[![release](https://img.shields.io/github/v/release/mariano-tp/k8s-admin-ops-kit?display_name=tag&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/releases)
[![license: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)
[![stars](https://img.shields.io/github/stars/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/stargazers)


# Kubernetes Admin Ops Kit

> Runbooks-as-code for typical **Kubernetes administrator** tasks. Includes **Ansible** for L2/L3 operations,
**Helm** for packaging a sample app, and **CI** with KinD. Ideal for interviews: showcases automation,
controlled rollouts, and health checks.

## Contents
- `helm/bot-platform/`: Helm chart with 3 Deployments (api/worker/nlp), PDB, NetworkPolicy, and probes.
- `ansible/playbooks/`: operation playbooks (ordered restart, cordon/drain, rollback, secret rotation).
- `scripts/`: scripts to spin up a **KinD** cluster and run smoke tests.
- `.github/workflows/ci.yml`: CI that creates KinD, runs Helm lint, installs the chart, executes Ansible, and runs smoke tests.
- `observability/`: base values for kube-prometheus-stack (optional).
- `runbooks/`: short SOPs for operations.

> Local requirements (optional): Docker + KinD + kubectl + Helm + Python 3.11.

In CI (GitHub Actions) no setup is required: the workflow provisions everything and validates.

## Quick start (local, Linux/macOS)
```bash
# 1) Spin up KinD
./scripts/kind-up.sh

# 2) Install the chart (namespace bot)
helm upgrade --install bot-platform ./helm/bot-platform -n bot --create-namespace

# 3) Wait for readiness
kubectl -n bot rollout status deploy -l app.kubernetes.io/name=bot-platform --timeout=300s

# 4) Execute ordered restart with Ansible
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r ansible/collections/requirements.yml
export K8S_AUTH_KUBECONFIG=$HOME/.kube/config
ansible-playbook ansible/playbooks/restart-platform.yml -e namespace=bot

# 5) Smoke test
./scripts/smoke.sh
```

## Structure
```
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
```

## CI
Each push/PR triggers the workflow that:
1. Creates KinD on an Ubuntu runner.
2. Runs `helm lint` and deploys the chart.
3. Executes `ansible-playbook --check` on `restart-platform.yml`.
4. Waits for readiness and runs `scripts/smoke.sh`.

## Credits
Portfolio repository by @mariano-tp. Licensed under MIT.

See also: [Code of Conduct](./CODE_OF_CONDUCT.md) · [Contributing](./CONTRIBUTING.md) · [Security](./SECURITY.md)
