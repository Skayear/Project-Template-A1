
resource "aws_subnet" "subnet" {
  for_each = {for i, v in var.subnet_list:  i => v}       //bucle for each para iterar la lista de subredes (subnet_list)

  vpc_id     = var.vpc_id                   //id del vpc para generar las subredes
  cidr_block = each.value.cidr_block        //rango de ips con su mascara de subred
  availability_zone =  format("%s%s", var.region,each.value.az)     //availability zone de cada subred

  map_public_ip_on_launch = var.privacy == "public" ? true : false    //

  tags = {
    Name = format("%s-%s-%s", var.subnet_name,each.value.az,var.env_name)  //tag name de la subred
  }
}

##########################
## Public subnet routing            // rute tables: Una tabla de rutas contiene un conjunto de reglas, denominadas rutas, que determinan hacia dónde se dirige el tráfico de red desde su subred o puerta de enlace
########################## 
resource "aws_route_table" "route_table" {
  count = var.privacy == "public" ? 1 : 0

  vpc_id = var.vpc_id
}
 
resource "aws_route" "route" {
  count = var.privacy == "public" ? 1 : 0

  route_table_id         = aws_route_table.route_table.0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id

  depends_on = [ 
    aws_route_table.route_table
  ]
}
 
resource "aws_route_table_association" "route_table_association" {
  for_each = var.privacy == "public" ?  aws_subnet.subnet : {}
 
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.0.id

  depends_on = [ 
    aws_route_table.route_table
  ]
}
  
###########################
## Private Subnet routing
###########################
resource "aws_eip" "eip" {
  for_each = var.privacy == "private" ? aws_subnet.subnet : {} 
 
  vpc = true
 
}
 
resource "aws_nat_gateway" "nat" {
  count = var.privacy == "private" ? length(aws_subnet.subnet) : 0

  allocation_id = element([for eip in aws_eip.eip : eip.id], count.index)
  subnet_id     = aws_subnet.public_nat_subnet.0.id

  tags = {
    Name = format("%s-%s-%s-nat", var.subnet_name,element([for subnet in var.subnet_list: subnet.az], count.index),var.env_name) 
  } 
 
}

resource "aws_route_table" "private_route_table" {
  count = var.privacy == "private" ? length(aws_subnet.subnet) : 0

  vpc_id = var.vpc_id 
}

resource "aws_route" "private_route" {
  count = var.privacy == "private" ? length(aws_subnet.subnet) : 0 
 
  route_table_id         = element([for route_table in aws_route_table.private_route_table : route_table.id], count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element([for nat in aws_nat_gateway.nat : nat.id], count.index)  ////Puede usar una puerta de enlace NAT para que las instancias en una subred privada puedan conectarse a servicios fuera de su VPC, pero los servicios externos no pueden iniciar una conexión con esas instancias.
}
 
resource "aws_route_table_association" "private_route_table_association" {
  count =  var.privacy == "private" ? length(aws_subnet.subnet) : 0 

  subnet_id      = element([for subnet in aws_subnet.subnet : subnet.id], count.index)
  route_table_id = element([for route_table  in aws_route_table.private_route_table : route_table .id], count.index)
}

resource "aws_subnet" "public_nat_subnet" {
  count = var.privacy == "private" ? 1 : 0
 
  vpc_id     = var.vpc_id
  cidr_block = "10.0.7.0/24"
  availability_zone =  format("%s%s", var.region,"a") 

  map_public_ip_on_launch = true 

  tags = {
    Name = format("%s-%s-%s-nat", var.subnet_name,"a",var.env_name) 
  }
}
 
resource "aws_route_table" "nat_public_route_table" {
  count = var.privacy == "private" ? 1 : 0

  vpc_id = var.vpc_id 
}
 
resource "aws_route" "nat_public_route" {         //las instancias en subredes privadas pueden conectarse a Internet a través de una puerta de enlace NAT pública, pero no pueden recibir conexiones entrantes no solicitadas desde Internet. Crea una puerta de enlace NAT pública en una subred pública y debe asociar una dirección IP elástica con la puerta de enlace NAT en el momento de la creación.
  count = var.privacy == "private" ? 1 : 0 
 
  route_table_id         = aws_route_table.nat_public_route_table.0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id         = var.igw_id
}
 
resource "aws_route_table_association" "nat_public_route_table_association" {
  count =  var.privacy == "private" ? 1 : 0 
 
  subnet_id      = aws_subnet.public_nat_subnet.0.id
  route_table_id = aws_route_table.nat_public_route_table.0.id
 
}