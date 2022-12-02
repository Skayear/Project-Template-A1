locals {

  // Shared configs
  application_name = var.application_name
  prefix           = var.prefix
  env_name         = var.env_name
  account_id       = var.account_id
  ssh_bucket       = "test-terraform-states-templete"
  ssh_key          = "./../ssh_keys/dev"
  region           = var.region

  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}a"]
  env_full_name      = "${local.prefix}-${local.env_name}"

  vpc_name       = "ECS-VPC-${local.env_full_name}"
  vpc_cdir_block = "10.0.0.0/16"

  public_subnet_name = "Public ECS SubNet"
  public_subnet_list = [{
    az         = "a"
    cidr_block = "10.0.1.0/24"
    },
    {
      az         = "b"
      cidr_block = "10.0.2.0/24"
  }]

  private_subnet_name = "Private ECS SubNet"
  private_subnet_list = [{
    az         = "a"
    cidr_block = "10.0.3.0/24"
    },
    {
      az         = "b"
      cidr_block = "10.0.4.0/24"
  }]

  isolated_subnet_name = "Isolated DBs SubNet"
  isolated_subnet_list = [{
    az         = "a"
    cidr_block = "10.0.5.0/24"
    },
    {
      az         = "b"
      cidr_block = "10.0.6.0/24"
  }]

  ##################
  ## KMS
  ##################
  aws_kms_alias_name = "${local.application_name}-${local.env_name}"
  use_encryption     = false

  ##################
  ## S3 bucket
  ##################
  use_s3 = false

  ##################
  ## Runner Config
  ##################
  runner_image_id      = "ami-0beaa649c482330f7"
  runner_instance_type = "t2.micro"
  runner_instance_name = "GitLab_runner_dev"
  runner_key_file      = "../../ssh_key/dev/runner_key.pub"
  runner_count         = 1

  #################
  ## RDS Config 
  #################
  cluster_identifier      = ""
  rds_identifier          = "dbpportal-db-${local.env_name}"
  rds_allocated_storage   = "20"
  rds_engine              = var.rds_engine
  rds_engine_version      = var.rds_engine_version
  rds_instance_class      = var.rds_instance_class
  rds_multi_az            = false
  rds_database_name       = var.rds_database_name
  rds_database_username   = var.rds_database_username
  rds_database_password   = var.rds_database_password
  rds_deletion_protection = false
  rds_apply_immediately   = true
  rds_storage_encrypted   = false
  rds_monitoring_interval = 0

}

module "shared" {
  source = "./../../System/shared"

  env_name      = local.env_name
  region        = local.region
  env_full_name = local.env_full_name

  /*VPC*/

  vpc_name       = local.vpc_name
  vpc_cdir_block = local.vpc_cdir_block

  /*VPC Subnets*/

  public_subnet_name = local.public_subnet_name
  public_subnet_list = local.public_subnet_list

  private_subnet_name = local.private_subnet_name
  private_subnet_list = local.private_subnet_list

  isolated_subnet_name = local.isolated_subnet_name
  isolated_subnet_list = local.isolated_subnet_list

  /*Runner*/

  runner_image_id      = local.runner_image_id
  runner_instance_type = local.runner_instance_type
  runner_instance_name = local.runner_instance_name
  runner_key_file      = local.runner_key_file
  runner_count         = local.runner_count

  /*S3*/

  use_s3 = local.use_s3

  //ssh_key_file = local.ssh_key_file_ecs
  //ssh_bucket = data.aws_s3_bucket.ssh_bucket

  /*RDS*/

  rds_identifier          = local.rds_identifier
  rds_allocated_storage   = local.rds_allocated_storage
  rds_engine              = local.rds_engine
  rds_engine_version      = local.rds_engine_version
  rds_instance_class      = local.rds_instance_class
  rds_multi_az            = local.rds_multi_az
  rds_database_name       = local.rds_database_name
  rds_database_username   = local.rds_database_username
  rds_database_password   = local.rds_database_password
  rds_deletion_protection = local.rds_deletion_protection
  rds_apply_immediately   = local.rds_apply_immediately
  rds_storage_encrypted   = local.use_encryption
  rds_monitoring_interval = local.rds_monitoring_interval

  use_encryption     = local.use_encryption
  aws_kms_alias_name = local.aws_kms_alias_name

}