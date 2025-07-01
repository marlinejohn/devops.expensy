# Infrastructure: Terraform Setup for Expensy EKS Cluster

This directory contains the Terraform configuration used to provision AWS infrastructure for the **Expensy** platform, including an Amazon EKS (Elastic Kubernetes Service) cluster.

---

## 🔧 What’s Included

- VPC and public/private subnets (via AWS VPC module)
- EKS cluster and managed node group
- IAM configuration for admin user `marline`
- Security groups for control plane access (port 443)
- Terraform state stored locally (can be changed to remote later)

---

## 🚀 Getting Started

### 1. Prerequisites

Ensure the following tools are installed on your machine:

- [Terraform v1.5+](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- IAM user `marline` with `AmazonEKSAdminPolicy` access
- AWS credentials configured:

```bash
aws configure --profile marline
```

---

### 2. Initialize & Apply Terraform

From inside the `/infrastructure` folder, run:

```bash
terraform init
terraform plan
terraform apply
```

This will create the VPC, EKS cluster, and other related AWS resources.

---

### 3. Connect to EKS Cluster

Once Terraform apply is complete, set up your kubeconfig:

```bash
AWS_PROFILE=marline aws eks update-kubeconfig \
  --region eu-north-1 \
  --name marline-expensy-cluster
```

Verify access:

```bash
kubectl get nodes
```

---

## 🔒 .gitignore

Make sure the following sensitive or environment-specific files are excluded from version control:

```
*.tfstate
*.tfstate.backup
.terraform/
terraform.tfvars
```

---

## 📁 Folder Structure

```
infrastructure/
├── main.tf             # Core EKS and modules
├── providers.tf        # AWS provider config
├── variables.tf        # Input variables
├── outputs.tf          # Output values
├── .gitignore          # Git exclusions
└── README.md           # This file
```

---

## 🗂️ Next Steps

- Write Kubernetes manifests (e.g., `deployment.yaml`, `service.yaml`) for backend and frontend
- Create ConfigMaps and Secrets for environment variables
- Deploy workloads using `kubectl apply -f`

---

## 🙌 Author

Terraform setup maintained by **Marline** for the **Expensy** platform.  
Brought to life with zero drama and maximum automation.
