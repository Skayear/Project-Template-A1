locals {

  // Shared configs
  application_name = "test-template"
  prefix           = "test-t"
  env_name         = "dev"
  account_id       = "292454637569"
  ssh_bucket       = "test-terraform-states-templete"
  ssh_key          = "./../ssh_keys/dev"
  region = "us-east-2"

  availability_zones = ["${var.region}a", "${var.region}b","${var.region}a"]
  env_full_name = "${local.prefix}-${local.env_name}"

  vpc_name       = "ECS-VPC-${local.env_full_name}"
  vpc_cdir_block = "10.0.0.0/16"

  public_subnet_name = "Public ECS SubNet"
  public_subnet_list = [{
    az = "a"
    cidr_block = "10.0.1.0/24"
  },
  {
    az = "b"
    cidr_block = "10.0.2.0/24"
  }]

  private_subnet_name = "Private ECS SubNet"
  private_subnet_list = [{
    az = "a"
    cidr_block = "10.0.3.0/24"
  },
  {
    az = "b"
    cidr_block = "10.0.4.0/24"
  }]

  isolated_subnet_name = "Isolated DBs SubNet"
  isolated_subnet_list = [{
    az = "a"
    cidr_block = "10.0.5.0/24"
  },
  {
    az = "b"
    cidr_block = "10.0.6.0/24"
  }]

  ##################
  ## S3 bucket
  ##################
  use_s3 = false

  ##################
  ## Runner Config
  ##################
  runner_image_id                   = "ami-0beaa649c482330f7"
  runner_instance_type              = "t2.micro"
  runner_instance_name              = "GitLab_runner_dev"
  runner_key_file                   = "../../ssh_key/dev/runner_key.pub"
  runner_count                      = 1

}

module "shared"{
  source = "./../../System/shared"

  env_name = local.env_name
  region = local.region
  env_full_name = local.env_full_name

  /*VPC*/

  vpc_name = local.vpc_name
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
  runner_key_file = local.runner_key_file
  runner_count = local.runner_count

  /*S3*/

  use_s3 = local.use_s3

  //ssh_key_file = local.ssh_key_file_ecs
  //ssh_bucket = data.aws_s3_bucket.ssh_bucket
}