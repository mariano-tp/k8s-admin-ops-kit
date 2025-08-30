# 01 - Reinicio ordenado de plataforma

**Objetivo:** reiniciar `api → worker → nlp` garantizando disponibilidad.

```bash
ansible-playbook ansible/playbooks/restart-platform.yml -e namespace=bot
```
**Rollback:** usar `ansible/playbooks/rollout-undo.yml` sobre el deployment impactado.
