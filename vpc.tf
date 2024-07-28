locals {
  cluster-name = "terraform-eks"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  intra_subnets = var.intra_subnets
  map_public_ip_on_launch = true


  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name                                          = "jenkins-vpc"
    "kubernetes.io/cluster/${local.cluster-name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster-name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}