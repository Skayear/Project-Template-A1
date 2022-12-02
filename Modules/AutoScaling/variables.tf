variable "env_full_name" {
  
}

variable "aux_access_sg" {
  
}

 
variable "cluster_name" {
  description = "Name of the ECS cluster"
}


variable "image_id" {
  description = "Image of the EC2 instances to be created."
  nullable = true
  default = null
}


variable "instance_type" {
  description = "Type of EC2 instances to create"
  nullable = true
  default = null
}

variable "ssh_bucket" {
  
}

variable "ssh_key" {
  
}

variable "ec2_min_size" {
  
}

variable "ec2_max_size" {
  
}

variable "ec2_desired_capacity" {
  
}

variable "vpc_id" {
  
}

variable "subnet_ids" {
  
}