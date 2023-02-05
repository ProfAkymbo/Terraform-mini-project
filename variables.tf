#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-1"
}
#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user"
  type        = string
  sensitive   = true
}
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  default    = "oyebanjiakeem.me"
  type        = string
  description = "Domain name"
}

