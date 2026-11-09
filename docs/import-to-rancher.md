# Import the cluster into Rancher

The cluster is created independently. Importing it does not replace RKE2 or recreate nodes; Rancher deploys management agents into the existing cluster.

## Procedure

1. Sign in to the Rancher management server.
2. Select **Cluster Management** and create/import an existing generic Kubernetes cluster.
3. Use a descriptive name such as `rke2-workload`.
4. Review the generated import command and destination URL.
5. From an administration host configured for this downstream cluster, execute the Rancher-generated command.
6. Wait for both Rancher agents to become healthy.
7. Confirm all three control-plane nodes and seven workers appear in Rancher.

## Validation

```bash
kubectl -n cattle-system get pods -o wide
kubectl -n cattle-system rollout status deployment/cattle-cluster-agent --timeout=10m
```

The exact command is deliberately not stored in this repository because it contains a management-server URL and import token generated for a specific Rancher environment.

## Troubleshooting checklist

- Downstream nodes can resolve the Rancher hostname.
- Downstream nodes trust the Rancher TLS certificate.
- Outbound HTTPS to Rancher is allowed.
- The `cattle-system` namespace is not blocked by admission policies.
- System clocks are synchronized.
- Proxy and `NO_PROXY` settings include cluster and service networks when required.

