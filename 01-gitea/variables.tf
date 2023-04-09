# VPC
variable "assessment_vpc" {
  description = "VPC for assessment environment"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "it defines the tenancy of VPC. Whether it's defsult or dedicated"
  type        = string
  default     = "default"
}

# private key
variable "ssh_private_key" {
  description = "pem file of Keypair used to login to EC2 instances"
  type        = string
  default     = "~/.ssh/crossrt_aws.pem"
}
