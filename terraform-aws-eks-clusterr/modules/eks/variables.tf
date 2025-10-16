variable "cluster_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "node_instance_type" {}
variable "desired_capacity" {}
variable "max_capacity" {}
variable "min_capacity" {}
variable "cluster_iam_role_arn" {}
variable "node_group_iam_role_arn" {}
variable "key_name" {}


