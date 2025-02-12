terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = ">= 2.0.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
}
