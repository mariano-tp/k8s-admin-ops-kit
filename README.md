> Available languages / Idiomas disponibles: [*English*](README.md) / [*Español*](README.ES.md)

Back to repository: [Home](https://github.com/metorresponce/metorresponce/blob/main/README.md)

[![ci](https://img.shields.io/github/actions/workflow/status/metorresponce/k8s-admin-ops-kit/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/actions/workflows/ci.yml)
[![last commit](https://img.shields.io/github/last-commit/metorresponce/k8s-admin-ops-kit?style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/commits/main)
[![release](https://img.shields.io/github/v/release/metorresponce/k8s-admin-ops-kit?display_name=tag&style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/releases)
[![license: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)
[![stars](https://img.shields.io/github/stars/metorresponce/k8s-admin-ops-kit?style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/stargazers)

# Kubernetes Admin Ops Kit

Runbooks-as-code for common Kubernetes administration tasks, focused on controlled operations, reproducible validation, and safer operational practices.

This repository includes Ansible playbooks for L2/L3 operational tasks, a Helm-packaged sample platform, Kubernetes operational controls, and CI validation using an ephemeral KinD cluster in GitHub Actions.

The goal is to demonstrate how operational automation, health checks, rollout control, and infrastructure validation can support reliability, incident readiness, and technology risk reduction in Kubernetes environments.

## Why this repository exists

Kubernetes operations often involve repetitive tasks that can become risky when executed manually, inconsistently, or without validation.

This lab shows how common administrative actions can be documented, automated, tested, and reviewed as code. It is not a production system, but a reproducible technical demonstration of practices that can be adapted to real environments.

## Risk and operational value

This repository focuses on:

- Reducing manual operational errors through repeatable playbooks
- Validating Kubernetes changes before relying on them
- Supporting controlled rollouts and rollback procedures
- Documenting operational actions as reviewable runbooks
- Testing readiness, health checks, and basic service continuity
- Demonstrating how CI can be used to validate infrastructure behavior
- Connecting technical operations with risk reduction and incident readiness

## What gets validated in CI

The GitHub Actions workflow provisions an ephemeral KinD cluster and validates the full operational flow:

- Creates a KinD cluster on an Ubuntu runner
- Runs Helm chart validation with lint and template
- Installs the sample platform into Kubernetes
- Checks deployment rollout and readiness
- Executes Ansible playbooks for basic operational tasks
- Runs a smoke test to confirm that the platform is healthy

Evidence is available in the workflow logs under GitHub Actions.

## Technical scope

The repository includes:

- A Helm chart with three sample workloads: api, worker, and nlp
- Kubernetes probes for health and readiness validation
- PodDisruptionBudget for basic availability control
- NetworkPolicy for basic traffic restriction
- Ansible playbooks for operational procedures
- KinD-based validation for local or CI execution
- Short runbooks for operational documentation
- Optional observability values for kube-prometheus-stack

## Contents

- `helm/bot-platform/` - Helm chart with Deployments, Services, probes, PDB, and NetworkPolicy
- `ansible/playbooks/` - Operational playbooks for restart, cordon/drain, rollback, and secret rotation
- `scripts/` - Scripts to create a KinD cluster and run smoke tests
- `.github/workflows/ci.yml` - CI workflow that validates the complete flow
- `observability/` - Base values for kube-prometheus-stack
- `runbooks/` - Short SOPs for operational tasks

## Validate online with GitHub Actions

1. Push this repository to GitHub
2. Go to `Actions`
3. Select `ci`
4. Run the workflow
5. Review the workflow logs and validation results

The workflow should complete successfully and provide evidence of the validated operations.

## Quick start

Local setup is optional. It can be useful for development, troubleshooting, or reviewing the workflow manually.

```bash
./scripts/kind-up.sh
```

```bash
helm upgrade --install bot-platform ./helm/bot-platform -n bot --create-namespace
```

```bash
kubectl -n bot rollout status deploy -l app.kubernetes.io/name=bot-platform --timeout=300s
```

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r ansible/collections/requirements.yml
export K8S_AUTH_KUBECONFIG=$HOME/.kube/config
ansible-playbook ansible/playbooks/restart-platform.yml -e namespace=bot
```

```bash
./scripts/smoke.sh
```

## Structure

```text
k8s-admin-ops-kit/
├─ ansible/
│  ├─ inventory/hosts.ini
│  ├─ collections/requirements.yml
│  └─ playbooks/
│     ├─ restart-platform.yml
│     ├─ cordon-drain-node.yml
│     ├─ rollout-undo.yml
│     └─ rotate-secret.yml
├─ helm/
│  └─ bot-platform/
│     ├─ Chart.yaml
│     ├─ values.yaml
│     └─ templates/
│        ├─ deploy-api.yaml
│        ├─ deploy-worker.yaml
│        ├─ deploy-nlp.yaml
│        ├─ svc-api.yaml
│        └─ netpol.yaml
├─ scripts/
│  ├─ kind-up.sh
│  ├─ kind-down.sh
│  └─ smoke.sh
├─ runbooks/
│  ├─ 01-restart-platform.md
│  └─ 02-node-maintenance.md
├─ observability/kube-prometheus-stack-values.yaml
├─ .github/workflows/ci.yml
├─ requirements.txt
├─ LICENSE
└─ README.md
```

## CI workflow summary

Each push or pull request triggers a workflow that:

1. Creates a KinD cluster on an Ubuntu runner
2. Runs Helm validation
3. Installs the sample platform
4. Executes Ansible automation
5. Waits for readiness
6. Runs `scripts/smoke.sh`
7. Reports the result in GitHub Actions

## Security and limitations

This repository is a public technical demonstration. It does not contain client data, production credentials, corporate infrastructure details, or confidential operational procedures.

The sample workloads are intentionally simple. Their purpose is to support validation of Kubernetes operational patterns, not to represent a complete production application.

No real secrets are included. Any required credentials or tokens should be provided through local environment variables or configuration files excluded from version control.

## Possible extensions

This lab can be extended with:

- Additional runbooks for incident response scenarios
- Prometheus rules for operational alerts
- Grafana dashboards for workload visibility
- More advanced NetworkPolicy examples
- Admission control validation
- Backup and recovery procedures
- Policy-as-code checks
- Security scanning in CI

## Credits

Portfolio repository by [@metorresponce](https://github.com/metorresponce). Licensed under MIT.

See also: [Code of Conduct](./CODE_OF_CONDUCT.md) · [Contributing](./CONTRIBUTING.md) · [Security](./SECURITY.md)
