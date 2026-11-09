# GitHub Actions Secrets

If a protected deployment workflow is added later, `RKE2_TOKEN` may be stored as a GitHub Actions Secret instead of being committed. Use a protected Environment with required approval and a trusted self-hosted runner that can reach the nodes.

Do not store sensitive values in repository files, workflow logs, pull requests, or screenshots. Avoid a cluster-admin kubeconfig when a narrowly scoped service account is sufficient. The validation workflow in this portfolio repository does not consume secrets.
