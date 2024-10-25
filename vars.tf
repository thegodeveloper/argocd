variable "eks-name" {
  type    = string
  default = "docker-desktop"
}

variable "env" {
  default = "dev"
}

variable "github_token" {
  type = string
}

variable "github_user" {
  type = string
}
