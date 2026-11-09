# Operations runbook

## Health checks

```bash
kubectl get --raw='/readyz?verbose'
kubectl get nodes
kubectl get pods -A
```

## Services

```bash
sudo systemctl status rke2-server  # control-plane nodes
sudo systemctl status rke2-agent   # worker nodes
```

## etcd protection

Snapshots run every six hours with a local retention of 20. Replicate them to protected external storage and test restoration regularly.

```bash
sudo rke2 etcd-snapshot ls
sudo rke2 etcd-snapshot save --name manual-before-change
```

## Safe upgrade sequence

1. Verify Rancher compatibility if the cluster is imported.
2. Take and export an etcd snapshot.
3. Upgrade one server at a time, keeping etcd quorum available.
4. Upgrade workers in controlled batches while respecting workload disruption budgets.
5. Run `bash scripts/validate-cluster.sh` after every phase.

