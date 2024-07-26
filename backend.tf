terraform {
  backend "s3" {
    bucket = "jenkins-terraform-eks-s3backend"
    key    = "jenkins/terraform.tfstate"
    region = "ca-central-1"

  }
}