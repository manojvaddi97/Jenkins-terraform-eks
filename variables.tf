variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string

}

variable "public_subnets" {
  description = "public subnet CIDR"
  type        = list(string)

}

variable "private_subnets" {
  description = "private subnet CIDR"
  type        = list(string)

}

variable "ec2_instance_type" {
  description = "instance type"
  type        = string

}