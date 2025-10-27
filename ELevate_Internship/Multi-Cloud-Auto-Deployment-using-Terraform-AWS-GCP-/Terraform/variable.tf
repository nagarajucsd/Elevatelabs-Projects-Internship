variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "gcp_project" {}
variable "gcp_credentials_file" {
  default = "gcp-key.json"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "gcp_machine_type" {
  default = "e2-micro"
}
