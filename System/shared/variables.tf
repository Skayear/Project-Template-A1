##############
# General Vars
##############
variable "env_name" {

}

variable "region" {

}

variable "env_full_name" {

}
##############
# VPC Vars
##############
variable "vpc_name" {

}

variable "vpc_cdir_block" {

}

#######################
# Public SubNet Vars
#######################
variable "public_subnet_name" {

}

variable "public_subnet_list" {
  type = list(object({
        az = string
        cidr_block= string
    }))

}


#######################
# Private SubNet Vars
#######################
variable "private_subnet_name" {

}


variable "private_subnet_list" {
    type = list(object({
        az = string
        cidr_block= string
    }))

}

#######################
# Isolated SubNet Vars
#######################
variable "isolated_subnet_name" {

}

variable "isolated_subnet_list" {
    type = list(object({
        az = string
        cidr_block= string
    }))

}

############ S3 BUCKET ###########################################################
variable "use_s3"{}

##################
## Runner Vars
##################

variable "runner_instance_name" {

}

variable "runner_instance_type" {

}

variable "runner_image_id" {

}

variable "runner_key_file" {

}

variable "runner_count" {

}