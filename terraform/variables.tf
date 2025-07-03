# variables.tf
variable "aws_region" {
  default = "ap-southeast-1"
}

variable "aws_profile" {
  default = "default"
}

variable "ami_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {}
variable "db_name" {
  default = "webapp"
}
variable "db_user" {
  default = "admin"
}
variable "db_password" {}
variable "s3_bucket_name" {}

