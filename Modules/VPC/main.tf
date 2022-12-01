/*====
The VPC
======*/  
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cdir_block   //Atributo para el rango de ips y su mascara

  enable_dns_support = true       //Genera dns para los recursos dentro de la vps
  enable_dns_hostnames = true     //Genera hostname para los recursos
  tags = {
    Name = format("%s%s",  var.vpc_name,var.env_name ), Env = "${var.env_name}"   //cadena interpolada para el nombre de la vpc
  }
} 
 
resource "aws_internet_gateway" "IGW" {  
  vpc_id = aws_vpc.vpc.id                   //salida para la vpc con el recurso vpc internet gateway
}
 