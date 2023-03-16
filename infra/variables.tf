# ElasticSearch
variable "elastic_search_domain_name" {
    type = string
}
variable "elastic_search_index_name" { 
  type = string
}
variable "elastic_search_instance_type" {
  type = string
}
variable "elastic_search_instance_count" {
  type = number
}
variable "elastic_search_ebs_size" {
  type = number
}
variable "elastic_search_master_user_name" {
  type = string
}
variable "elastic_search_master_password" {
  type = string
}

# S3
variable "s3_bucket_name" {
  type = string
}
variable "s3_bucket_prefix" {
  type = string
}
variable "s3_bucket_error_prefix" { 
  type = string
}
variable "s3_backup_mode" {
  type = string
}

# Kinesis Firehose
variable "firehose_stream_name" {
    type = string
}
variable "firehose_role_name" {
  type = string
}
variable "firehose_role_elastic_search_policy_name" {
  type = string
}
variable "firehose_role_s3_policy_name" {
  type = string
}

# Lambda
variable "lambda_name" {
  type = string
}
variable "lambda_role_name" {
  type = string
}
variable "lambda_role_policy_name" {
  type = string
}
variable "lambda_layer_name" {
  type = string
}
