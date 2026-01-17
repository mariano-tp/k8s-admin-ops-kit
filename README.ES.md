> Available languages / Idiomas disponibles: [*English*](README.md) / [*Español*](README.ES.md)

Back to repository: [Home](https://github.com/mariano-tp/mariano-tp/blob/main/README.ES.md)

[![ci](https://img.shields.io/github/actions/workflow/status/mariano-tp/k8s-admin-ops-kit/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/actions/workflows/ci.yml)
[![last commit](https://img.shields.io/github/last-commit/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/commits/main)
[![release](https://img.shields.io/github/v/release/mariano-tp/k8s-admin-ops-kit?display_name=tag&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/releases)
[![license: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)
[![stars](https://img.shields.io/github/stars/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/stargazers)

# Kubernetes Admin Ops Kit

Runbooks-as-code para tareas típicas de administración de Kubernetes. Incluye Ansible para operaciones L2/L3, Helm para empaquetar una app de ejemplo, y CI con KinD.

Está pensado para entrevistas técnicas: muestra automatización, rollouts controlados, health checks y validación reproducible completamente dentro de GitHub Actions.

## Qué se valida en CI (GitHub Actions)
El workflow provisiona todo en un clúster KinD efímero y valida el flujo completo:

- Crea un clúster KinD en un runner Ubuntu
- Valida el chart Helm (lint + template)
- Instala el chart y verifica rollouts/readiness
- Ejecuta playbooks Ansible (smoke + tareas operativas básicas)
- Corre un smoke test para confirmar que la plataforma está saludable

Evidencia: logs del workflow en Actions.

## Contenidos
- helm/bot-platform/ - Helm chart con 3 Deployments (api/worker/nlp), PDB, NetworkPolicy y probes
- ansible/playbooks/ - Playbooks operativos (reinicio ordenado, cordon/drain, rollback, rotación de secrets)
- scripts/ - Scripts para levantar KinD y ejecutar smoke tests
- .github/workflows/ci.yml - CI que crea KinD, valida Helm, instala el chart, corre Ansible y ejecuta smoke tests
- observability/ - Valores base para kube-prometheus-stack (opcional)
- runbooks/ - SOPs cortos para operaciones

## Validación 100% online (GitHub Actions)
1. Subí este repo a GitHub
2. Entrá a Actions -> ci -> Run workflow
3. El workflow debería quedar en verde

## Inicio rápido (local opcional)
El setup local es opcional. Puede servir para desarrollo y troubleshooting.

    ./scripts/kind-up.sh

    helm upgrade --install bot-platform ./helm/bot-platform -n bot --create-namespace

    kubectl -n bot rollout status deploy -l app.kubernetes.io/name=bot-platform --timeout=300s

    python3 -m venv .venv && source .venv/bin/activate
    pip install -r requirements.txt
    ansible-galaxy collection install -r ansible/collections/requirements.yml
    export K8S_AUTH_KUBECONFIG=$HOME/.kube/config
    ansible-playbook ansible/playbooks/restart-platform.yml -e namespace=bot

    ./scripts/smoke.sh

## Estructura
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

## Resumen del workflow de CI
Cada push/PR dispara el workflow que:
1. Crea KinD en un runner Ubuntu
2. Valida Helm e instala el chart
3. Ejecuta automatización con Ansible (tareas operativas básicas)
4. Espera readiness y corre scripts/smoke.sh

## Créditos
Repositorio de portfolio por @mariano-tp. Licencia MIT.

Ver también: [Code of Conduct](./CODE_OF_CONDUCT.md) · [Contributing](./CONTRIBUTING.md) · [Security](./SECURITY.md)
