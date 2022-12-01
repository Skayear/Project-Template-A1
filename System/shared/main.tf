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