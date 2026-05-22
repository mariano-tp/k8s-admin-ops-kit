> Available languages / Idiomas disponibles: [*English*](README.md) / [*Español*](README.ES.md)

Volver al repositorio: [Home](https://github.com/metorresponce/metorresponce/blob/main/README.ES.md)

[![ci](https://img.shields.io/github/actions/workflow/status/metorresponce/k8s-admin-ops-kit/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/actions/workflows/ci.yml)
[![last commit](https://img.shields.io/github/last-commit/metorresponce/k8s-admin-ops-kit?style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/commits/main)
[![release](https://img.shields.io/github/v/release/metorresponce/k8s-admin-ops-kit?display_name=tag&style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/releases)
[![license: MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](./LICENSE)
[![stars](https://img.shields.io/github/stars/metorresponce/k8s-admin-ops-kit?style=flat-square)](https://github.com/metorresponce/k8s-admin-ops-kit/stargazers)

# Kubernetes Admin Ops Kit

Runbooks-as-code para tareas habituales de administración de Kubernetes, con foco en operaciones controladas, validación reproducible y prácticas operativas más seguras.

Este repositorio incluye playbooks de Ansible para tareas operativas L2/L3, una plataforma de ejemplo empaquetada con Helm, controles operativos de Kubernetes y validación en CI mediante un clúster KinD efímero en GitHub Actions.

El objetivo es demostrar cómo la automatización operativa, los health checks, el control de rollouts y la validación de infraestructura pueden contribuir a la confiabilidad, la preparación ante incidentes y la reducción de riesgos tecnológicos en entornos Kubernetes.

## Por qué existe este repositorio

Las operaciones sobre Kubernetes suelen incluir tareas repetitivas que pueden volverse riesgosas cuando se ejecutan de forma manual, inconsistente o sin validación previa.

Este laboratorio muestra cómo ciertas acciones administrativas comunes pueden documentarse, automatizarse, probarse y revisarse como código. No representa un sistema productivo completo, sino una demostración técnica reproducible de prácticas que pueden adaptarse a entornos reales.

## Valor operativo y de riesgo

Este repositorio se enfoca en:

- Reducir errores operativos manuales mediante playbooks repetibles
- Validar cambios en Kubernetes antes de depender de ellos
- Apoyar rollouts controlados y procedimientos de rollback
- Documentar acciones operativas como runbooks revisables
- Probar readiness, health checks y continuidad básica del servicio
- Demostrar cómo CI puede utilizarse para validar comportamiento de infraestructura
- Conectar la operación técnica con reducción de riesgo y preparación ante incidentes

## Qué se valida en CI

El workflow de GitHub Actions provisiona un clúster KinD efímero y valida el flujo operativo completo:

- Crea un clúster KinD en un runner Ubuntu
- Ejecuta validación del chart Helm con lint y template
- Instala la plataforma de ejemplo en Kubernetes
- Verifica rollout y readiness de los deployments
- Ejecuta playbooks de Ansible para tareas operativas básicas
- Corre un smoke test para confirmar que la plataforma está saludable

La evidencia queda disponible en los logs del workflow dentro de GitHub Actions.

## Alcance técnico

El repositorio incluye:

- Un chart Helm con tres workloads de ejemplo: api, worker y nlp
- Probes de Kubernetes para validación de salud y readiness
- PodDisruptionBudget para control básico de disponibilidad
- NetworkPolicy para restricción básica de tráfico
- Playbooks de Ansible para procedimientos operativos
- Validación basada en KinD para ejecución local o en CI
- Runbooks cortos para documentación operativa
- Valores opcionales de observabilidad para kube-prometheus-stack

## Contenidos

- `helm/bot-platform/` - Chart Helm con Deployments, Services, probes, PDB y NetworkPolicy
- `ansible/playbooks/` - Playbooks operativos para reinicio, cordon/drain, rollback y rotación de secrets
- `scripts/` - Scripts para crear un clúster KinD y ejecutar smoke tests
- `.github/workflows/ci.yml` - Workflow de CI que valida el flujo completo
- `observability/` - Valores base para kube-prometheus-stack
- `runbooks/` - SOPs cortos para tareas operativas

## Validación online con GitHub Actions

1. Subir este repositorio a GitHub
2. Entrar en `Actions`
3. Seleccionar `ci`
4. Ejecutar el workflow
5. Revisar los logs y resultados de validación

El workflow debería finalizar correctamente y aportar evidencia de las operaciones validadas.

## Inicio rápido

El setup local es opcional. Puede ser útil para desarrollo, troubleshooting o revisión manual del flujo.

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

## Estructura

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

## Resumen del workflow de CI

Cada push o pull request dispara un workflow que:

1. Crea un clúster KinD en un runner Ubuntu
2. Ejecuta validación de Helm
3. Instala la plataforma de ejemplo
4. Ejecuta automatización con Ansible
5. Espera readiness
6. Corre `scripts/smoke.sh`
7. Reporta el resultado en GitHub Actions

## Seguridad y limitaciones

Este repositorio es una demostración técnica pública. No contiene datos de clientes, credenciales productivas, detalles de infraestructura corporativa ni procedimientos operativos confidenciales.

Los workloads de ejemplo son intencionalmente simples. Su finalidad es apoyar la validación de patrones operativos en Kubernetes, no representar una aplicación productiva completa.

No se incluyen secretos reales. Cualquier credencial o token necesario debería proporcionarse mediante variables de entorno locales o archivos de configuración excluidos del control de versiones.

## Posibles extensiones

Este laboratorio puede ampliarse con:

- Runbooks adicionales para escenarios de respuesta a incidentes
- Reglas de Prometheus para alertas operativas
- Dashboards de Grafana para visibilidad de workloads
- Ejemplos más avanzados de NetworkPolicy
- Validación de admission control
- Procedimientos de backup y recuperación
- Checks de policy-as-code
- Escaneo de seguridad en CI

## Créditos

Repositorio de portfolio por [@metorresponce](https://github.com/metorresponce). Licencia MIT.

Ver también: [Code of Conduct](./CODE_OF_CONDUCT.md) · [Contributing](./CONTRIBUTING.md) · [Security](./SECURITY.md)
