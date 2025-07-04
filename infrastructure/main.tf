module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "marline-expensy-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project = "expensy"
    Owner   = "Marline"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.11.1"

  cluster_name    = "marline-expensy-cluster"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
}
resource "aws_eks_access_entry" "marline_access" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::438465169137:user/marline"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "marline_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.marline_access.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  access_scope {
    type = "cluster"
  }
}
resource "aws_security_group_rule" "eks_control_plane_https_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.eks.cluster_security_group_id
  cidr_blocks       = ["0.0.0.0/0"] 
  description       = "Allow HTTPS access to EKS control plane for Marline"
}

resource "aws_eks_access_policy_association" "marline_clusteradmin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.marline_access.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "~> 20.0"

  cluster_name                      = module.eks.cluster_name
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  subnet_ids                        = module.vpc.private_subnets

  name = "marline-expensy-nodes"

  desired_size = 3
  max_size     = 4
  min_size     = 1

   instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  cluster_service_cidr = "172.20.0.0/16"

  bootstrap_extra_args = "--use-max-pods false --kubelet-extra-args '--max-pods=110'"
}

