[![ci](https://img.shields.io/github/actions/workflow/status/mariano-tp/k8s-admin-ops-kit/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/actions/workflows/ci.yml)
[![last commit](https://img.shields.io/github/last-commit/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/commits/main)
[![release](https://img.shields.io/github/v/release/mariano-tp/k8s-admin-ops-kit?display_name=tag&style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/releases)
[![license: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)
[![stars](https://img.shields.io/github/stars/mariano-tp/k8s-admin-ops-kit?style=flat-square)](https://github.com/mariano-tp/k8s-admin-ops-kit/stargazers)


# Kubernetes Admin Ops Kit

> Runbooks-as-code para tareas típicas de un **Administrador de Kubernetes**. Incluye **Ansible** para operaciones L2/L3,
**Helm** para empaquetar una app de ejemplo y **CI** con KinD. Ideal para entrevistas: muestra automatización,
despliegues controlados y checks de salud.

## Contenido
- `helm/bot-platform/`: chart Helm con 3 Deployments (api/worker/nlp), PDB, NetworkPolicy y probes.
- `ansible/playbooks/`: playbooks de operaciones (reinicio ordenado, cordon/drain, rollback, rotación de secretos).
- `scripts/`: scripts para levantar un clúster **KinD** y hacer smoke tests.
- `.github/workflows/ci.yml`: CI que crea KinD, lint de Helm, instala el chart, ejecuta Ansible y smoke test.
- `observability/`: valores base para kube-prometheus-stack (opcional).
- `runbooks/`: SOPs breves de las operaciones.

> ⚠️ Requisitos locales (opcional): Docker + KinD + kubectl + Helm + Python 3.11.

En CI (GitHub Actions) no se requiere configurar nada: el workflow crea todo y valida.

## Uso rápido (local, Linux/macOS)
```bash
# 1) Levantar KinD
./scripts/kind-up.sh

# 2) Instalar el chart (namespace bot)
helm upgrade --install bot-platform ./helm/bot-platform -n bot --create-namespace

# 3) Esperar readiness
kubectl -n bot rollout status deploy -l app.kubernetes.io/name=bot-platform --timeout=300s

# 4) Ejecutar reinicio ordenado con Ansible
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r ansible/collections/requirements.yml
export K8S_AUTH_KUBECONFIG=$HOME/.kube/config
ansible-playbook ansible/playbooks/restart-platform.yml -e namespace=bot

# 5) Smoke test
./scripts/smoke.sh

```

## Estructura
```
k8s-admin-ops-kit/
├─ ansible/
│ ├─ inventory/hosts.ini
│ ├─ collections/requirements.yml
│ └─ playbooks/
│ ├─ restart-platform.yml
│ ├─ cordon-drain-node.yml
│ ├─ rollout-undo.yml
│ └─ rotate-secret.yml
├─ helm/
│ └─ bot-platform/
│ ├─ Chart.yaml
│ ├─ values.yaml
│ └─ templates/
│ ├─ deploy-api.yaml
│ ├─ deploy-worker.yaml
│ ├─ deploy-nlp.yaml
│ ├─ svc-api.yaml
│ └─ netpol.yaml
├─ scripts/
│ ├─ kind-up.sh
│ ├─ kind-down.sh
│ └─ smoke.sh
├─ runbooks/
│ ├─ 01-restart-plataforma.md
│ └─ 02-mantenimiento-nodo.md
├─ observability/kube-prometheus-stack-values.yaml
├─ .github/workflows/ci.yml
├─ requirements.txt
├─ LICENSE
└─ README.md

```


## CI
Cada push/PR dispara el workflow que:
1. Crea KinD en Ubuntu runner.
2. `helm lint` y despliegue del chart.
3. `ansible-playbook --check` de `restart-platform.yml`.
4. Espera readiness y ejecuta `scripts/smoke.sh`.


## Créditos
Repositorio de portfolio por @mariano-tp. Licencia MIT.

Ver también: [Código de Conducta](./CODE_OF_CONDUCT.md) · [Contribuir](./CONTRIBUTING.md) · [Seguridad](./SECURITY.md)
