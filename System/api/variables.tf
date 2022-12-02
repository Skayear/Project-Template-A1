####################
## ALB Variables
####################
variable "load_balancer_certificate_arn" {
  description = "The certificate arn to use HTTPS on the load balancer"
}

variable "health_check_path" {
  description = "The path where the load balancer should ping the application to be sure its online"
}

variable "load_balancer_protcol" {
  description = ""
}

variable "target_group_registration_port" {
  description = ""
}

variable "target_group_registration_potocol" {
  description = ""
}

variable "https" {
  description = "Boolean to define if it uses only https to connect"
} 

variable "alb_subnets_id" {

}
 
variable "vpc_id" {
  description = "VPC where the resource is going to be created." 
}