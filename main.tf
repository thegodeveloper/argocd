locals {
  argo_values = templatefile("${path.module}/values.yaml", {})
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.7.1" #"6.7.11"
  timeout    = "1500"
  namespace  = kubernetes_namespace.argocd.id
  values = [local.argo_values]
}

resource "null_resource" "password" {
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_secret_v1" "ssh_key" {
  metadata {
    name      = "private-repo-ssh-key"
    namespace = kubernetes_namespace.argocd.id
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    "sshPrivateKey" = file("${path.module}/argocd/id_rsa")
    "type"          = "git"
    "url"           = "git@github.com:thegodeveloper/gitops-argocd.git"
    "name"          = "github"
    "project"       = "default"
  }
}