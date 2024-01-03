terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }

    random = {
      source  = "hashicorp/random"
    }

    tls = {
      source  = "hashicorp/tls"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}