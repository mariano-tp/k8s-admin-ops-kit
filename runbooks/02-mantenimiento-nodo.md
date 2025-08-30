# 02 - Mantenimiento de nodo (cordon & drain)

```bash
ansible-playbook ansible/playbooks/cordon-drain-node.yml -e node=<node-name>
```
Para devolver el nodo: `kubectl uncordon <node>`.
