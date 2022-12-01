variable "ami_id" {
  description = ""
}

variable "instance_type" {
  description = ""
}

variable "instance_name" {
  description = ""
}

variable "ssh_key_file" {

}

variable "env_full_name" {

}

variable "instance_count" {

}

variable "security_groups"{
  default     = []
  description = "The security_groups for ec2"
}