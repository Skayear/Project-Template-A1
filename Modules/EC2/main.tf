resource "aws_key_pair" "key" {                   //claves de acceso ssh a la instacia
  key_name   = "${var.env_full_name}-key"         //nombre de la clave por medio de cadena interpolada
  public_key = file(var.ssh_key_file)             //ruta de las clave ssh 
}

resource "aws_instance" "ec2" {                   // crea la instacia en este recurso
  count = var.instance_count                      //numero de instacias

  ami           = var.ami_id                      //ami o imagen del sistema operativo
  instance_type = var.instance_type               //tipo de instacia
  key_name      = aws_key_pair.key.key_name       //referencia a las claves ssh

  vpc_security_group_ids = var.security_groups    //firewall de la instacia

  tags = {
    Name = var.instance_name                      //tag name de la instacia
  }
}