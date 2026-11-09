#!/usr/bin/env bash
set -euo pipefail

require_value() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Required environment variable is missing: ${name}" >&2
    exit 1
  fi
}

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script as root or with sudo." >&2
  exit 1
fi

require_value RKE2_TOKEN
require_value RKE2_SERVER
require_value NODE_NAME
require_value NODE_IP

RKE2_CHANNEL="${RKE2_CHANNEL:-stable}"
NODE_LABELS="${NODE_LABELS:-workload-tier=general,node-pool=worker}"

if [[ -n "${RKE2_VERSION:-}" ]]; then
  export INSTALL_RKE2_VERSION="${RKE2_VERSION}"
fi

curl --proto '=https' --tlsv1.2 -sfL https://get.rke2.io | \
  INSTALL_RKE2_TYPE=agent sh -s - --channel "${RKE2_CHANNEL}"

install -d -m 0700 /etc/rancher/rke2
umask 077
{
  printf 'server: %s\n' "${RKE2_SERVER}"
  printf 'token: %s\n' "${RKE2_TOKEN}"
  printf 'node-name: %s\n' "${NODE_NAME}"
  printf 'node-ip: %s\n' "${NODE_IP}"
  printf 'node-label:\n'
  IFS=',' read -ra labels <<<"${NODE_LABELS}"
  for label in "${labels[@]}"; do
    printf '  - %s\n' "${label}"
  done
} > /etc/rancher/rke2/config.yaml

chmod 0600 /etc/rancher/rke2/config.yaml
systemctl enable --now rke2-agent
echo "RKE2 agent installation started for ${NODE_NAME}."

