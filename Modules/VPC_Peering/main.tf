/*====
The VPC peering
======*/  
resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = data.aws_vpc.runner_vpc.id
  vpc_id        = data.aws_vpc.environment_vpc.id
  
  auto_accept   = true

  tags = {
    Name = "VPC Peering between runner and ${var.environment}"
  }
}

data "aws_vpc" "runner_vpc" {
  id = var.vpc_id_runner
}

data "aws_vpc" "environment_vpc" {
  id = var.vpc_id_environment
}

resource "aws_route" "runner_to_bds" {
  //from runner perspective
  route_table_id            = var.runner_route_table
  destination_cidr_block    = var.cidr_block_bds
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  depends_on                = [aws_vpc_peering_connection.foo]
}

resource "aws_route" "bds_to_runner" {
  //from Bds perspective
  route_table_id            = var.bds_route_table
  destination_cidr_block    = var.cidr_block_runner
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  depends_on                = [aws_vpc_peering_connection.foo]
}