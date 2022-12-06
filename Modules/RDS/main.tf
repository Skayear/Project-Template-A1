###########
### RDS ###
###########
resource "aws_db_instance" "rds" {
  identifier              = var.identifier                      // (Opcional, Fuerza nuevo recurso) El nombre de la instancia de RDS, si se omite, Terraform asignará un identificador único y aleatorio.
  allocated_storage       = var.allocated_storage               /// (Obligatorio) El almacenamiento asignado en gibibytes
  engine                  = var.engine                          /// (Obligatorio) El motor de base de datos que se va a utilizar.
  engine_version          = var.engine_version                  // (Opcional) La versión del motor a utilizar.
  instance_class          = var.instance_class                  /// (Obligatorio) El tipo de instancia de la instancia de RDS.
  multi_az                = var.multi_az                        // (Opcional) Especifica si la instancia de RDS es multi-AZ
  name                    = var.database_name                   // (Opcional) Nombre de la base de datos
  username                = var.database_username               // Usuario BDD
  password                = var.database_password               // Contraseña BDD
  db_subnet_group_name    = var.subnet_group_id                 // (Opcional) Nombre del grupo de subred de base de datos . La instancia de base de datos se creará en la VPC asociada con el grupo de subred de base de datos. Si no se especifica, se creará en la default VPC
  vpc_security_group_ids  = [var.security_group_ids]            // (Opcional) Lista de grupos de seguridad de VPC para asociar.
  skip_final_snapshot     = false                               // (Opcional) Determina si se crea una instantánea de base de datos final antes de que se elimine la instancia de base de datos. Si se especifica true, no se crea una instantánea DBS. Si se especifica false, se crea una instantánea de base de datos antes de que se elimine la instancia de base de datos, utilizando el valor de final_snapshot_identifier
  backup_retention_period = 7                                   // (Opcional) Los días para conservar las copias de seguridad. Debe estar entre 0y 35. El valor predeterminado es 0
  backup_window           = "02:00-06:00"                       // (Opcional) La ventana para realizar el mantenimiento. Sintaxis: "ddd:hh24:mi-ddd:hh24:mi". Por ejemplo: "Lun:00:00-Lun:03:00".
  publicly_accessible     = var.publicly_accessible             // (Opcional) Bool para controlar si la instancia es de acceso público. El valor predeterminado es false
  deletion_protection     = var.deletion_protection             // (Opcional) Si la instancia de base de datos debe tener habilitada la protección contra eliminación. La base de datos no se puede eliminar cuando este valor se establece en true. El valor predeterminado es false
  apply_immediately       = var.apply_immediately               // (Opcional) Especifica si las modificaciones de la base de datos se aplican inmediatamente o durante la próxima ventana de mantenimiento. El valor predeterminado es false
  storage_encrypted       = var.storage_encrypted               // (Opcional) Especifica si la instancia de base de datos está cifrada. Tenga en cuenta que si está creando una réplica de lectura entre regiones, este campo se ignora y, en su lugar, debe declararlo kms_key_idcon un ARN válido. El valor predeterminado es falsesi no se especifica.
  monitoring_interval     = var.monitoring_interval             // (Opcional) El intervalo, en segundos, entre puntos cuando se recopilan métricas de Monitoreo mejorado para la instancia de base de datos. Para deshabilitar la recopilación de métricas de Supervisión mejorada, especifique 0. El valor predeterminado es 0. Valores válidos: 0, 1, 5, 10, 15, 30, 60.
  kms_key_id = var.kms_key_id                                   // (Opcional) El ARN de la clave de cifrado de KMS. Si crea una réplica cifrada, establezca esto en el ARN de KMS de destino.

  tags = {
    Environment = var.env_name                                  // tag environment para la instacia RDS
  }
} 