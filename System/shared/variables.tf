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

####################
##### RDS Vars #####
####################

variable "rds_identifier" {
  description = "Identifier of database"
}
 
variable "rds_allocated_storage" {
  default     = "20"
  description = "The storage size in GB"
}

variable "rds_instance_class" {
  description = "The instance type"
}

variable "rds_multi_az" {
  default     = false
  description = "Muti-az allowed?"
}

variable "rds_database_name" {
  description = "The database name"
}

variable "rds_database_username" {
  description = "The username of the database"
}

variable "rds_database_password" {
  description = "The password of the database"
}

variable "rds_engine" {
  description = "The database engine"
}

variable "rds_engine_version" {
  description = "The database engine version"
}

variable "rds_publicly_accessible" {
  default = true
}

variable "rds_deletion_protection" {
  default = false
}

variable "rds_storage_encrypted" {
  default = false
}

variable "rds_apply_immediately" {
  default = true
}

variable "rds_monitoring_interval" {
  default = 0
} 


############ KMS KEY ############

variable "use_encryption"{}
variable "aws_kms_alias_name"{}