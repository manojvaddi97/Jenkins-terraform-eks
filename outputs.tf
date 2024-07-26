output "vpc_name" {
  value = module.vpc.name

}

output "instance_publicIP" {
  value = module.ec2_instance.public_ip

}