# ArgoCD

## How run the terraform code

### Terraform init

```shell
terraform init
```

### Terraform plan

```shell
terraform plan -var "github_user=USERNAME" -var "github_token=GITHUB_TOKEN"
```

### Terraform apply

```shell
terraform apply -var "github_user=USERNAME" -var "github_token=GITHUB_TOKEN" -auto-approve
```

