resource "aws_iam_role" "firehose_role" {
  name = var.firehose_role_name

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Principal: {
          Service: "firehose.amazonaws.com"
        },
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_role_s3_policy" {
  name        = var.firehose_role_s3_policy_name
  path        = "/"
  description = "Policy to a Kinesis Firehose send records to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          var.s3_bucket_arn,
          format("%s/*", var.s3_bucket_arn)
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_firehose_rule_s3_policy" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_role_s3_policy.arn
}

resource "aws_iam_policy" "firehose_role_elastic_search_policy" {
  name        = var.firehose_role_elastic_search_policy_name
  path        = "/"
  description = "Policy to a Kinesis Firehose send records to Elastic Search"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttpPut",
          "es:ESHttpPost",
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:DescribeElasticsearchDomainConfig",
        ]
        Effect   = "Allow"
        Resource = [
          var.elastic_search_domain_arn,
          format("%s/*", var.elastic_search_domain_arn)
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_firehose_rule_elastic_search_policy" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_role_elastic_search_policy.arn
}

resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = var.firehose_stream_name
  destination = "elasticsearch"

  elasticsearch_configuration {
    domain_arn     = var.elastic_search_domain_arn
    index_name     = var.elastic_search_index_name
    role_arn       = aws_iam_role.firehose_role.arn
    s3_backup_mode = var.s3_backup_mode
  }

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = var.s3_bucket_arn

    prefix = var.s3_bucket_prefix
    error_output_prefix = var.s3_bucket_error_prefix
  }
}
