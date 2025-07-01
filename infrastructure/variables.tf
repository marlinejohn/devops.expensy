variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "marline-expensy-cluster"
  type        = string
  default     = "marline-expensy-cluster"
}
