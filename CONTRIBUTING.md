# Guía de Contribución

Gracias por tu interés 🙌. Este repo está pensado para ser **simple, reproducible y didáctico**.

## Flujo de trabajo
- Abrí un issue usando la plantilla (Bug / Mejora / Runbook nuevo).
- Creá una rama desde `main`:
  - `feat/<breve-descripcion>` para nuevas features (playbooks, templates, scripts).
  - `fix/<breve-descripcion>` para bugs.
  - `docs/...`, `ci/...` para documentación o pipelines.
- Commits estilo [Conventional Commits](https://www.conventionalcommits.org):
  - `feat:`, `fix:`, `docs:`, `ci:`, `chore:`

## Pull Request
- Un solo tema por PR.
- Link al issue correspondiente.
- Pasar todos los checks de CI (GitHub Actions).
- Actualizar `README.md` y/o `runbooks/` si aplica.
- Explicar en la descripción qué operación de K8s cubre o qué cambia en el chart.

## Estilo / calidad
- Markdown simple y claro (en español).
- Mantener consistencia de badges y secciones en el `README.md`.
- Documentar variables, flags o parámetros adicionales en playbooks.
- Usar `/images` para capturas o diagramas si corresponde.
- Nombres de playbooks y roles en minúsculas con guiones.

## CI
Los PRs deben quedar en verde ✅:
- `helm lint ./helm/bot-platform`
- Deploy en KinD con `--wait` sin errores.
- `ansible-playbook --check` de `restart-platform.yml` OK.
- `./scripts/smoke.sh` pasando.

## Licencia
Al contribuir aceptás que tu aporte se publica bajo **MIT** (ver [LICENSE](./LICENSE)).
