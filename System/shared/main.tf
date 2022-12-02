module "VPC" {
  source = "../../Modules/VPC"

  env_name = var.env_name
  vpc_name = var.vpc_name
  vpc_cdir_block = var.vpc_cdir_block
}

module "private_subnets" {
  source = "../../Modules/Subnet"

  env_name = var.env_name
  region = var.region

  vpc_id = module.VPC.vpc_id
  igw_id = module.VPC.igw_id

  subnet_name = var.private_subnet_name
  subnet_list = var.private_subnet_list
  privacy = "private"

}

module "public_subnets" {
  source = "../../Modules/Subnet"

  env_name = var.env_name
  region = var.region

  vpc_id = module.VPC.vpc_id
  igw_id = module.VPC.igw_id

  subnet_name = var.public_subnet_name
  subnet_list = var.public_subnet_list
  privacy = "public"

}

module "isolated_subnets" {
  source = "../../Modules/Subnet"

  env_name = var.env_name
  region = var.region

  vpc_id = module.VPC.vpc_id
  igw_id = module.VPC.igw_id

  subnet_name = var.isolated_subnet_name
  subnet_list = var.isolated_subnet_list
  privacy = "isolated"

}

module "runner" {
  source = "../../Modules/EC2"

  env_full_name = "runner_${var.env_full_name}"

  instance_name = var.runner_instance_name
  instance_type = var.runner_instance_type
  ami_id = var.runner_image_id
  ssh_key_file = var.runner_key_file
  instance_count = var.runner_count
}

module "s3" {
  source = "../../Modules/S3"

  count = var.use_s3 ? 1 : 0

  bucket_name = "bucket-${var.env_full_name}"

  env_name = "${var.env_full_name}"
}

# module "RDS_networking" {
#   source = "../../Modules/RDS_networking"
    
#   env_name = var.env_name
#   vpc_id =  module.VPC.vpc_id 
#   env_full_name = var.env_full_name 
#   subnet_ids = module.public_subnets.subnet_ids
#   ec2_sgs = module.autoscaling.ec2_security_group

#   #migrator_runner = var.migrator_runner
# }


module "RDS" {
  source = "../../Modules/RDS"

  identifier              = var.rds_identifier
  allocated_storage       = var.rds_allocated_storage
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_instance_class
  multi_az                = var.rds_multi_az
  database_name           = var.rds_database_name
  database_username       = var.rds_database_username
  database_password       = var.rds_database_password
  subnet_ids              = module.public_subnets.subnet_ids
  subnet_group_id         = module.RDS_networking.subnet_group_id
  security_group_ids      = module.RDS_networking.security_group_ids
  deletion_protection     = var.rds_deletion_protection
  apply_immediately       = var.rds_apply_immediately
  monitoring_interval     = var.rds_monitoring_interval
  env_name                = var.env_name
  publicly_accessible     = true
  
  storage_encrypted       = var.use_encryption
  kms_key_id = var.use_encryption ? module.kms_key[0].kms_key_id : null
}

module "kms_key"{
  source        = "../../Modules/kmsEncription"
  
  count = var.use_encryption ? 1 : 0
  aws_kms_alias_name = var.aws_kms_alias_name
}