#!/usr/bin/env bash
set -euo pipefail

command -v kubectl >/dev/null 2>&1 || {
  echo "kubectl is required." >&2
  exit 1
}

kubectl get --raw='/readyz?verbose'
kubectl wait --for=condition=Ready nodes --all --timeout=15m
kubectl get nodes -o wide
kubectl -n kube-system get pods -o wide

control_planes="$(kubectl get nodes -l node-role.kubernetes.io/control-plane -o name | wc -l | tr -d ' ')"
workers="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o name | wc -l | tr -d ' ')"
total="$(kubectl get nodes -o name | wc -l | tr -d ' ')"

if [[ "${control_planes}" -ne 3 || "${workers}" -ne 7 || "${total}" -ne 10 ]]; then
  echo "Unexpected topology: control-plane=${control_planes}, workers=${workers}, total=${total}." >&2
  exit 1
fi

echo "Downstream cluster topology and readiness validated successfully."

