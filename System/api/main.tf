# module "alb" {
#   source = "../../modules/LoadBalancer"
  
#   service_full_name                 = local.service_full_name
#   env_full_name = var.env_full_name
#   vpc_id                            = var.vpc_id
#   subnet_ids                        = var.alb_subnets_id
#   security_group_ids                = var.security_group_ids
#   ecs_inbound_sg                    = module.ecs_service_task.ecs_tasks_sg
#   environment                       = var.env_name
#   load_balancer_protcol             = var.load_balancer_protcol
#   target_group_registration_port    = var.target_group_registration_port
#   target_group_registration_potocol = var.target_group_registration_potocol

#   certificate_arn = var.load_balancer_certificate_arn
#   health_check_path = var.health_check_path
#   https = var.https
  
# }
