# FluxCD Setup

FluxCD is used to manage Kubernetes resources and core components. You'll need either a GitHub App (recommended) or Personal Access Token.

## GitHub App Setup (Recommended)

1. Create GitHub App:
   - Go to GitHub Settings → Developer Settings → GitHub Apps → New GitHub App
   - Set Repository Permissions:
     - Contents: Read & Write
     - Commit statuses: Read & Write
     - Webhooks: Read & Write
   - Install on your repository

2. Add to `terraform.tfvars`:
```hcl
github_app_id              = "your-app-id"
github_app_installation_id = "your-installation-id"
github_app_pem            = "your-private-key"
```

## Alternative: Personal Access Token

1. Create fine-grained PAT with permissions:
   - Contents: Read & Write
   - Commit statuses: Read & Write
   - Webhooks: Read & Write

2. Add to `terraform.tfvars`:
```hcl
gh_token = "your-github-pat"
```

3. Store the PAT in OCI Vault with name `github-fluxcd-token`. This allows FluxCD to annotate GitHub commit status.

## Note
- Ensure `gitops/core` path exists in your repository
- The webhook secret is automatically stored in OCI Vault 