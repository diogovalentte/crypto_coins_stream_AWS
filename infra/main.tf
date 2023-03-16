provider "aws" {
    region = "us-east-1"
}

module elastic_search {
  source = "./modules/elastic_search"

  elastic_search_domain_name = var.elastic_search_domain_name
  elastic_search_index_name = var.elastic_search_index_name
  elastic_search_instance_type = var.elastic_search_instance_type
  elastic_search_instance_count = var.elastic_search_instance_count
  elastic_search_ebs_size = var.elastic_search_ebs_size
  elastic_search_master_user_name = var.elastic_search_master_user_name
  elastic_search_master_password = var.elastic_search_master_password
}

module s3 {
  source = "./modules/s3"

  s3_bucket_name = var.s3_bucket_name
}

module firehose {
  source = "./modules/firehose"

  firehose_stream_name = var.firehose_stream_name
  firehose_role_name = var.firehose_role_name
  firehose_role_s3_policy_name = var.firehose_role_s3_policy_name
  firehose_role_elastic_search_policy_name = var.firehose_role_elastic_search_policy_name

  s3_bucket_arn = module.s3.s3_bucket_arn
  s3_bucket_prefix = var.s3_bucket_prefix
  s3_bucket_error_prefix = var.s3_bucket_error_prefix
  s3_backup_mode = var.s3_backup_mode

  elastic_search_index_name = var.elastic_search_index_name
  elastic_search_domain_arn = module.elastic_search.elastic_search_domain_arn
}

module lambda {
  source = "./modules/lambda"

  lambda_name = var.lambda_name
  lambda_role_name = var.lambda_role_name
  lambda_role_policy_name = var.lambda_role_policy_name
  lambda_layer_name = var.lambda_layer_name

  firehose_stream_name = var.firehose_stream_name
  firehose_stream_arn = module.firehose.firehose_stream_arn
}
