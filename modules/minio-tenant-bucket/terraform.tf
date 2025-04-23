terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}
