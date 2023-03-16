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

# S3
variable "s3_bucket_arn" {
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

# ElasticSearch
variable "elastic_search_index_name" { 
  type = string
}
variable "elastic_search_domain_arn" { 
  type = string
}